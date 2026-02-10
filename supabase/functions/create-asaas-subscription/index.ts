/**
 * Edge Function: create-asaas-subscription
 *
 * Cria uma nova assinatura no Asaas e registra no banco de dados local
 *
 * Requisição:
 * POST /functions/v1/create-asaas-subscription
 * Authorization: Bearer <user-jwt-token>
 * Body:
 * {
 *   "planId": "uuid",
 *   "billingCycle": "monthly" | "yearly",
 *   "paymentMethod": "pix" | "boleto" | "credit_card"
 * }
 *
 * Resposta:
 * {
 *   "success": true,
 *   "data": {
 *     "subscription": { ... },
 *     "payment": {
 *       "invoiceUrl": "...",
 *       "pixQrCode": "...",
 *       "pixCopyPaste": "..."
 *     }
 *   }
 * }
 */

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import {
  createServiceClient,
  getAuthenticatedUser,
  successResponse,
  errorResponse,
  validateRequiredFields,
  logInfo,
  logError,
} from '../_shared/supabase-client.ts';
import {
  createOrUpdateAsaasCustomer,
  findAsaasCustomerByCpfCnpj,
  createAsaasSubscription,
  getAsaasPayment,
  getAsaasPixQrCode,
  getNextDueDate,
  getNextPeriodEnd,
  convertBillingCycleToAsaas,
  convertPaymentMethodToAsaas,
  cleanCpfCnpj,
  AsaasCustomerData,
  AsaasSubscriptionData,
} from '../_shared/asaas-api.ts';

const FUNCTION_NAME = 'create-asaas-subscription';

serve(async (req: Request) => {
  try {
    logInfo(FUNCTION_NAME, 'Iniciando criação de assinatura');

    // 1. Criar cliente Supabase
    const supabase = createServiceClient();

    // 2. Obter usuário autenticado
    const user = await getAuthenticatedUser(req, supabase);
    logInfo(FUNCTION_NAME, 'Usuário autenticado', { userId: user.id });

    // 3. Parse do body
    const body = await req.json();
    validateRequiredFields(body, ['planId', 'billingCycle', 'paymentMethod']);

    const { planId, billingCycle, paymentMethod } = body;

    // 4. Validar valores permitidos
    if (!['monthly', 'yearly'].includes(billingCycle)) {
      throw new Error('billingCycle deve ser "monthly" ou "yearly"');
    }

    if (!['pix', 'boleto', 'credit_card'].includes(paymentMethod)) {
      throw new Error('paymentMethod deve ser "pix", "boleto" ou "credit_card"');
    }

    // 5. Buscar dados do usuário
    const { data: userData, error: userError } = await supabase
      .from('users')
      .select('*')
      .eq('id', user.id)
      .single();

    if (userError || !userData) {
      throw new Error('Usuário não encontrado no banco de dados');
    }

    logInfo(FUNCTION_NAME, 'Dados do usuário obtidos', {
      email: userData.email,
      cpfcnpj: userData.cpfcnpj?.substring(0, 4) + '***', // Log parcial por segurança
    });

    // 6. Buscar plano de assinatura
    const { data: plan, error: planError } = await supabase
      .from('subscription_plans')
      .select('*')
      .eq('id', planId)
      .eq('is_active', true)
      .single();

    if (planError || !plan) {
      throw new Error('Plano de assinatura não encontrado ou inativo');
    }

    logInfo(FUNCTION_NAME, 'Plano selecionado', {
      planId: plan.id,
      name: plan.name,
      priceMonthly: plan.price_monthly,
      priceYearly: plan.price_yearly,
    });

    // 7. Verificar se usuário já tem assinatura ativa
    const { data: existingSubscription } = await supabase
      .from('subscriptions')
      .select('id, status')
      .eq('user_id', user.id)
      .eq('status', 'active')
      .single();

    if (existingSubscription) {
      throw new Error('Usuário já possui uma assinatura ativa');
    }

    // 8. Criar/Obter cliente no Asaas
    let asaasCustomer;
    const cpfCnpj = cleanCpfCnpj(userData.cpfcnpj || '');

    if (!cpfCnpj) {
      throw new Error('CPF/CNPJ do usuário não encontrado');
    }

    // Tentar buscar cliente existente
    try {
      asaasCustomer = await findAsaasCustomerByCpfCnpj(cpfCnpj);
      if (asaasCustomer) {
        logInfo(FUNCTION_NAME, 'Cliente Asaas existente encontrado', {
          customerId: asaasCustomer.id,
        });
      }
    } catch (error) {
      logInfo(FUNCTION_NAME, 'Cliente não encontrado, criando novo');
    }

    // Se não encontrou, criar novo cliente
    if (!asaasCustomer) {
      const customerData: AsaasCustomerData = {
        name: userData.display_name || userData.name_contractor || userData.email,
        email: userData.email,
        cpfCnpj: cpfCnpj,
        phone: userData.phone || undefined,
        mobilePhone: userData.phone || undefined,
        externalReference: user.id, // Referência ao user_id do Supabase
        notificationDisabled: false,
      };

      asaasCustomer = await createOrUpdateAsaasCustomer(customerData);
      logInfo(FUNCTION_NAME, 'Cliente Asaas criado', {
        customerId: asaasCustomer.id,
      });
    }

    // 9. Calcular valor da assinatura
    const subscriptionValue =
      billingCycle === 'yearly'
        ? parseFloat(plan.price_yearly || '0')
        : parseFloat(plan.price_monthly || '0');

    if (subscriptionValue <= 0) {
      throw new Error(`Valor inválido para o plano ${billingCycle}`);
    }

    // 10. Criar assinatura no Asaas
    const subscriptionData: AsaasSubscriptionData = {
      customer: asaasCustomer.id,
      billingType: convertPaymentMethodToAsaas(paymentMethod),
      value: subscriptionValue,
      nextDueDate: getNextDueDate(7), // Primeiro pagamento em 7 dias
      cycle: convertBillingCycleToAsaas(billingCycle),
      description: `${plan.name} - ${billingCycle === 'yearly' ? 'Anual' : 'Mensal'}`,
      externalReference: `${user.id}:${planId}`,
    };

    const asaasSubscription = await createAsaasSubscription(subscriptionData);
    logInfo(FUNCTION_NAME, 'Assinatura Asaas criada', {
      subscriptionId: asaasSubscription.id,
    });

    // 11. Salvar assinatura no banco local
    const currentPeriodStart = new Date();
    const currentPeriodEnd = getNextPeriodEnd(billingCycle);

    const { data: localSubscription, error: subscriptionError } = await supabase
      .from('subscriptions')
      .insert({
        user_id: user.id,
        plan_id: planId,
        asaas_subscription_id: asaasSubscription.id,
        asaas_customer_id: asaasCustomer.id,
        status: 'pending', // Aguardando pagamento
        billing_cycle: billingCycle,
        current_period_start: currentPeriodStart.toISOString(),
        current_period_end: currentPeriodEnd.toISOString(),
        cancel_at_period_end: false,
        metadata: {
          payment_method: paymentMethod,
          created_via: 'edge_function',
        },
      })
      .select()
      .single();

    if (subscriptionError) {
      logError(FUNCTION_NAME, subscriptionError);
      throw new Error('Erro ao salvar assinatura no banco de dados');
    }

    logInfo(FUNCTION_NAME, 'Assinatura local criada', {
      subscriptionId: localSubscription.id,
    });

    // 12. Buscar detalhes do primeiro pagamento gerado pelo Asaas
    // A API de assinaturas do Asaas cria automaticamente a primeira cobrança
    let paymentDetails: any = {};
    let pixQrCode: any = null;

    // Aguardar um momento para o Asaas processar a cobrança
    await new Promise((resolve) => setTimeout(resolve, 2000));

    // Buscar o primeiro pagamento gerado
    if (asaasSubscription.id) {
      try {
        // O ID do primeiro pagamento geralmente está no campo 'id' da subscription response
        // Ou podemos buscar via payments endpoint filtrando por subscription
        const firstPayment = await getAsaasPayment(asaasSubscription.id);

        paymentDetails = {
          id: firstPayment.id,
          invoiceUrl: firstPayment.invoiceUrl,
          bankSlipUrl: firstPayment.bankSlipUrl,
          value: firstPayment.value,
          dueDate: firstPayment.dueDate,
        };

        // Se for PIX, buscar QR Code
        if (paymentMethod === 'pix') {
          pixQrCode = await getAsaasPixQrCode(firstPayment.id);
          paymentDetails.pixQrCode = pixQrCode?.encodedImage;
          paymentDetails.pixCopyPaste = pixQrCode?.payload;
        }

        logInfo(FUNCTION_NAME, 'Detalhes do pagamento obtidos', {
          paymentId: firstPayment.id,
          hasPix: !!pixQrCode,
        });
      } catch (error) {
        logError(FUNCTION_NAME, error);
        // Não falhar se não conseguir buscar detalhes do pagamento
        // A assinatura já foi criada com sucesso
      }
    }

    // 13. Salvar transação de pagamento no banco local
    const { data: transaction, error: transactionError } = await supabase
      .from('payment_transactions')
      .insert({
        subscription_id: localSubscription.id,
        user_id: user.id,
        asaas_payment_id: paymentDetails.id || asaasSubscription.id,
        amount: subscriptionValue,
        currency: 'BRL',
        status: 'pending',
        payment_method: paymentMethod,
        due_date: paymentDetails.dueDate || getNextDueDate(7),
        invoice_url: paymentDetails.invoiceUrl || paymentDetails.bankSlipUrl,
        pix_qr_code: paymentDetails.pixQrCode,
        pix_copy_paste: paymentDetails.pixCopyPaste,
        metadata: {
          asaas_subscription_id: asaasSubscription.id,
          asaas_customer_id: asaasCustomer.id,
        },
      })
      .select()
      .single();

    if (transactionError) {
      logError(FUNCTION_NAME, transactionError);
      // Não falhar, pois a assinatura principal já foi criada
    }

    logInfo(FUNCTION_NAME, 'Transação de pagamento criada', {
      transactionId: transaction?.id,
    });

    // 14. Retornar resposta de sucesso
    return successResponse({
      subscription: localSubscription,
      payment: {
        invoiceUrl: paymentDetails.invoiceUrl || paymentDetails.bankSlipUrl,
        pixQrCode: paymentDetails.pixQrCode,
        pixCopyPaste: paymentDetails.pixCopyPaste,
        dueDate: paymentDetails.dueDate,
        value: subscriptionValue,
        paymentMethod: paymentMethod,
      },
      asaas: {
        subscriptionId: asaasSubscription.id,
        customerId: asaasCustomer.id,
      },
    });
  } catch (error) {
    logError(FUNCTION_NAME, error);
    return errorResponse(error.message || 'Erro ao criar assinatura');
  }
});
