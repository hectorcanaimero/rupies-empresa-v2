/**
 * Edge Function: handle-asaas-webhook
 *
 * Processa webhooks enviados pelo Asaas quando o status de pagamentos muda
 *
 * Eventos suportados:
 * - PAYMENT_CREATED: Pagamento criado
 * - PAYMENT_UPDATED: Pagamento atualizado
 * - PAYMENT_CONFIRMED: Pagamento confirmado (aguardando compensação)
 * - PAYMENT_RECEIVED: Pagamento recebido (compensado)
 * - PAYMENT_OVERDUE: Pagamento vencido
 * - PAYMENT_DELETED: Pagamento deletado
 * - PAYMENT_RESTORED: Pagamento restaurado
 * - PAYMENT_REFUNDED: Pagamento estornado
 * - PAYMENT_RECEIVED_IN_CASH: Pagamento recebido em dinheiro
 * - PAYMENT_CHARGEBACK_REQUESTED: Chargeback solicitado
 * - PAYMENT_CHARGEBACK_DISPUTE: Disputa de chargeback
 * - PAYMENT_AWAITING_CHARGEBACK_REVERSAL: Aguardando reversão de chargeback
 * - PAYMENT_DUNNING_RECEIVED: Cobrança de inadimplência recebida
 * - PAYMENT_DUNNING_REQUESTED: Cobrança de inadimplência solicitada
 * - PAYMENT_BANK_SLIP_VIEWED: Boleto visualizado
 * - PAYMENT_CHECKOUT_VIEWED: Checkout visualizado
 *
 * Requisição (enviada pelo Asaas):
 * POST /functions/v1/handle-asaas-webhook
 * Body:
 * {
 *   "event": "PAYMENT_RECEIVED",
 *   "payment": {
 *     "id": "pay_xxx",
 *     "customer": "cus_xxx",
 *     "subscription": "sub_xxx",
 *     "value": 99.90,
 *     "status": "RECEIVED",
 *     "dueDate": "2024-01-01",
 *     "paymentDate": "2024-01-01",
 *     ...
 *   }
 * }
 *
 * Resposta:
 * {
 *   "success": true,
 *   "data": {
 *     "processed": true,
 *     "eventType": "PAYMENT_RECEIVED"
 *   }
 * }
 */

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import {
  createServiceClient,
  successResponse,
  errorResponse,
  logInfo,
  logError,
} from '../_shared/supabase-client.ts';

const FUNCTION_NAME = 'handle-asaas-webhook';

/**
 * Mapeia status do Asaas para status interno
 */
function mapAsaasStatusToLocal(asaasStatus: string): string {
  const statusMap: Record<string, string> = {
    PENDING: 'pending',
    CONFIRMED: 'confirmed',
    RECEIVED: 'received',
    OVERDUE: 'overdue',
    REFUNDED: 'refunded',
    RECEIVED_IN_CASH: 'received',
    AWAITING_RISK_ANALYSIS: 'pending',
  };

  return statusMap[asaasStatus] || 'pending';
}

/**
 * Determina se o pagamento foi bem-sucedido
 */
function isPaymentSuccessful(status: string): boolean {
  return ['RECEIVED', 'CONFIRMED', 'RECEIVED_IN_CASH'].includes(status);
}

/**
 * Determina se a assinatura deve ser ativada
 */
function shouldActivateSubscription(status: string): boolean {
  return ['RECEIVED', 'CONFIRMED'].includes(status);
}

/**
 * Determina se a assinatura deve ser marcada como vencida
 */
function shouldMarkAsPastDue(status: string): boolean {
  return status === 'OVERDUE';
}

serve(async (req: Request) => {
  try {
    logInfo(FUNCTION_NAME, 'Webhook recebido do Asaas');

    // 1. Criar cliente Supabase
    const supabase = createServiceClient();

    // 2. Parse do body do webhook
    const webhookData = await req.json();
    const eventType = webhookData.event;
    const paymentData = webhookData.payment;

    if (!eventType || !paymentData) {
      throw new Error('Webhook inválido: event ou payment ausente');
    }

    logInfo(FUNCTION_NAME, 'Evento recebido', {
      event: eventType,
      paymentId: paymentData.id,
      status: paymentData.status,
      value: paymentData.value,
    });

    // 3. Processar apenas eventos de pagamento relevantes
    if (!eventType.startsWith('PAYMENT_')) {
      logInfo(FUNCTION_NAME, 'Evento ignorado (não é de pagamento)', { event: eventType });
      return successResponse({
        processed: false,
        reason: 'Evento não é de pagamento',
        eventType,
      });
    }

    // 4. Extrair dados do pagamento
    const asaasPaymentId = paymentData.id;
    const asaasStatus = paymentData.status;
    const localStatus = mapAsaasStatusToLocal(asaasStatus);
    const paymentDate = paymentData.paymentDate || null;
    const subscriptionId = paymentData.subscription || null;

    // 5. Buscar transação no banco de dados
    const { data: transaction, error: transactionError } = await supabase
      .from('payment_transactions')
      .select('*, subscriptions(id, status, user_id)')
      .eq('asaas_payment_id', asaasPaymentId)
      .single();

    if (transactionError) {
      // Se transação não existe, pode ser o primeiro pagamento
      // Vamos tentar buscar pela assinatura Asaas
      if (subscriptionId) {
        const { data: subscription } = await supabase
          .from('subscriptions')
          .select('id, user_id, status')
          .eq('asaas_subscription_id', subscriptionId)
          .single();

        if (subscription) {
          // Criar transação que estava faltando
          const { data: newTransaction, error: createError } = await supabase
            .from('payment_transactions')
            .insert({
              subscription_id: subscription.id,
              user_id: subscription.user_id,
              asaas_payment_id: asaasPaymentId,
              amount: paymentData.value,
              currency: 'BRL',
              status: localStatus,
              payment_method: paymentData.billingType?.toLowerCase() || 'undefined',
              due_date: paymentData.dueDate,
              payment_date: paymentDate,
              invoice_url: paymentData.invoiceUrl || paymentData.bankSlipUrl,
              metadata: {
                created_via: 'webhook',
                asaas_subscription_id: subscriptionId,
              },
            })
            .select('*, subscriptions(id, status, user_id)')
            .single();

          if (createError) {
            logError(FUNCTION_NAME, createError);
            throw new Error('Erro ao criar transação via webhook');
          }

          logInfo(FUNCTION_NAME, 'Transação criada via webhook', {
            transactionId: newTransaction.id,
          });

          // Continuar processamento com a nova transação
          await processPaymentUpdate(supabase, newTransaction, asaasStatus, paymentDate);

          return successResponse({
            processed: true,
            eventType,
            created: true,
            transactionId: newTransaction.id,
          });
        }
      }

      logError(FUNCTION_NAME, transactionError);
      throw new Error('Transação não encontrada no banco de dados');
    }

    logInfo(FUNCTION_NAME, 'Transação encontrada', {
      transactionId: transaction.id,
      currentStatus: transaction.status,
      newStatus: localStatus,
    });

    // 6. Processar atualização do pagamento
    await processPaymentUpdate(supabase, transaction, asaasStatus, paymentDate);

    // 7. Retornar sucesso
    return successResponse({
      processed: true,
      eventType,
      transactionId: transaction.id,
      oldStatus: transaction.status,
      newStatus: localStatus,
    });
  } catch (error) {
    logError(FUNCTION_NAME, error);
    return errorResponse(error.message || 'Erro ao processar webhook');
  }
});

/**
 * Processa a atualização de um pagamento
 */
async function processPaymentUpdate(
  supabase: any,
  transaction: any,
  asaasStatus: string,
  paymentDate: string | null
): Promise<void> {
  const localStatus = mapAsaasStatusToLocal(asaasStatus);
  const transactionId = transaction.id;
  const subscription = transaction.subscriptions;

  // 1. Atualizar transação
  const { error: updateError } = await supabase
    .from('payment_transactions')
    .update({
      status: localStatus,
      payment_date: paymentDate,
      updated_at: new Date().toISOString(),
    })
    .eq('id', transactionId);

  if (updateError) {
    logError(FUNCTION_NAME, updateError);
    throw new Error('Erro ao atualizar transação');
  }

  logInfo(FUNCTION_NAME, 'Transação atualizada', {
    transactionId,
    status: localStatus,
  });

  // 2. Se pagamento foi bem-sucedido, ativar assinatura
  if (shouldActivateSubscription(asaasStatus) && subscription) {
    const { error: subscriptionError } = await supabase
      .from('subscriptions')
      .update({
        status: 'active',
        updated_at: new Date().toISOString(),
      })
      .eq('id', subscription.id)
      .eq('status', 'pending'); // Só ativar se estiver pending

    if (subscriptionError) {
      logError(FUNCTION_NAME, subscriptionError);
      // Não falhar, apenas logar
    } else {
      logInfo(FUNCTION_NAME, 'Assinatura ativada', {
        subscriptionId: subscription.id,
      });
    }
  }

  // 3. Se pagamento vencido, marcar assinatura como past_due
  if (shouldMarkAsPastDue(asaasStatus) && subscription) {
    const { error: subscriptionError } = await supabase
      .from('subscriptions')
      .update({
        status: 'past_due',
        updated_at: new Date().toISOString(),
      })
      .eq('id', subscription.id);

    if (subscriptionError) {
      logError(FUNCTION_NAME, subscriptionError);
      // Não falhar, apenas logar
    } else {
      logInfo(FUNCTION_NAME, 'Assinatura marcada como vencida', {
        subscriptionId: subscription.id,
      });
    }
  }

  // 4. Se pagamento foi estornado, cancelar assinatura
  if (asaasStatus === 'REFUNDED' && subscription) {
    const { error: subscriptionError } = await supabase
      .from('subscriptions')
      .update({
        status: 'canceled',
        canceled_at: new Date().toISOString(),
        updated_at: new Date().toISOString(),
      })
      .eq('id', subscription.id);

    if (subscriptionError) {
      logError(FUNCTION_NAME, subscriptionError);
      // Não falhar, apenas logar
    } else {
      logInfo(FUNCTION_NAME, 'Assinatura cancelada (estorno)', {
        subscriptionId: subscription.id,
      });
    }
  }
}
