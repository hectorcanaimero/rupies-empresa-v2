/**
 * Edge Function: get-subscription-status
 *
 * Retorna o status da assinatura do usuário autenticado
 *
 * Requisição:
 * GET /functions/v1/get-subscription-status
 * Authorization: Bearer <user-jwt-token>
 *
 * Resposta:
 * {
 *   "success": true,
 *   "data": {
 *     "hasActiveSubscription": true,
 *     "isPremium": true,
 *     "subscription": {
 *       "id": "uuid",
 *       "status": "active",
 *       "planName": "Clube dos 100 - Mensal",
 *       "billingCycle": "monthly",
 *       "currentPeriodStart": "2024-01-01T00:00:00Z",
 *       "currentPeriodEnd": "2024-02-01T00:00:00Z",
 *       "cancelAtPeriodEnd": false,
 *       "canceledAt": null
 *     },
 *     "plan": {
 *       "id": "uuid",
 *       "name": "Clube dos 100 - Mensal",
 *       "priceMonthly": 99.90,
 *       "priceYearly": 959.04,
 *       "features": ["unlimited_posts", "priority_support"]
 *     },
 *     "features": ["unlimited_posts", "priority_support"],
 *     "usage": {
 *       "servicesThisMonth": 5,
 *       "maxServices": null
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
  logInfo,
  logError,
} from '../_shared/supabase-client.ts';

const FUNCTION_NAME = 'get-subscription-status';

serve(async (req: Request) => {
  try {
    logInfo(FUNCTION_NAME, 'Consultando status de assinatura');

    // 1. Criar cliente Supabase
    const supabase = createServiceClient();

    // 2. Obter usuário autenticado
    const user = await getAuthenticatedUser(req, supabase);
    logInfo(FUNCTION_NAME, 'Usuário autenticado', { userId: user.id });

    // 3. Usar a função PostgreSQL check_subscription_status
    const { data: statusData, error: statusError } = await supabase.rpc(
      'check_subscription_status',
      {
        p_user_id: user.id,
      }
    );

    if (statusError) {
      logError(FUNCTION_NAME, statusError);
      throw new Error('Erro ao verificar status de assinatura');
    }

    logInfo(FUNCTION_NAME, 'Status obtido via PostgreSQL function', {
      hasActiveSubscription: statusData.has_active_subscription,
      isPremium: statusData.is_premium,
    });

    // 4. Se não tem assinatura ativa, retornar resposta básica
    if (!statusData.has_active_subscription) {
      return successResponse({
        hasActiveSubscription: false,
        isPremium: false,
        subscription: null,
        plan: null,
        features: [],
        usage: {
          servicesThisMonth: 0,
          maxServices: null,
        },
      });
    }

    // 5. Buscar detalhes completos da assinatura
    const { data: subscription, error: subscriptionError } = await supabase
      .from('subscriptions')
      .select(
        `
        *,
        subscription_plans (
          id,
          name,
          description,
          price_monthly,
          price_yearly,
          features,
          max_services_per_month,
          max_contractors_contacted
        )
      `
      )
      .eq('user_id', user.id)
      .eq('status', 'active')
      .gt('current_period_end', new Date().toISOString())
      .order('created_at', { ascending: false })
      .limit(1)
      .single();

    if (subscriptionError || !subscription) {
      // Caso de inconsistência: função disse que tem assinatura mas não encontramos
      logError(FUNCTION_NAME, subscriptionError || 'Assinatura não encontrada');

      return successResponse({
        hasActiveSubscription: false,
        isPremium: false,
        subscription: null,
        plan: null,
        features: [],
        usage: {
          servicesThisMonth: 0,
          maxServices: null,
        },
      });
    }

    const plan = subscription.subscription_plans;

    // 6. Buscar uso atual do usuário (quantos serviços criou este mês)
    const startOfMonth = new Date();
    startOfMonth.setDate(1);
    startOfMonth.setHours(0, 0, 0, 0);

    const { count: servicesThisMonth, error: usageError } = await supabase
      .from('services')
      .select('id', { count: 'exact', head: true })
      .eq('user_id', user.id)
      .gte('created_at', startOfMonth.toISOString());

    if (usageError) {
      logError(FUNCTION_NAME, usageError);
      // Não falhar, apenas logar
    }

    // 7. Buscar histórico de pagamentos
    const { data: payments, error: paymentsError } = await supabase
      .from('payment_transactions')
      .select('id, amount, status, payment_date, payment_method')
      .eq('subscription_id', subscription.id)
      .order('created_at', { ascending: false })
      .limit(5);

    if (paymentsError) {
      logError(FUNCTION_NAME, paymentsError);
      // Não falhar, apenas logar
    }

    // 8. Calcular próximo pagamento
    let nextPayment = null;
    if (!subscription.cancel_at_period_end) {
      const { data: upcomingPayment } = await supabase
        .from('payment_transactions')
        .select('due_date, amount, status, payment_method')
        .eq('subscription_id', subscription.id)
        .eq('status', 'pending')
        .order('due_date', { ascending: true })
        .limit(1)
        .single();

      if (upcomingPayment) {
        nextPayment = {
          dueDate: upcomingPayment.due_date,
          amount: upcomingPayment.amount,
          paymentMethod: upcomingPayment.payment_method,
        };
      }
    }

    // 9. Retornar resposta completa
    return successResponse({
      hasActiveSubscription: true,
      isPremium: true,
      subscription: {
        id: subscription.id,
        status: subscription.status,
        planName: plan.name,
        billingCycle: subscription.billing_cycle,
        currentPeriodStart: subscription.current_period_start,
        currentPeriodEnd: subscription.current_period_end,
        cancelAtPeriodEnd: subscription.cancel_at_period_end,
        canceledAt: subscription.canceled_at,
        trialEnd: subscription.trial_end,
        createdAt: subscription.created_at,
      },
      plan: {
        id: plan.id,
        name: plan.name,
        description: plan.description,
        priceMonthly: plan.price_monthly,
        priceYearly: plan.price_yearly,
        features: plan.features || [],
        maxServicesPerMonth: plan.max_services_per_month,
        maxContractorsContacted: plan.max_contractors_contacted,
      },
      features: plan.features || [],
      usage: {
        servicesThisMonth: servicesThisMonth || 0,
        maxServices: plan.max_services_per_month,
        percentageUsed:
          plan.max_services_per_month && servicesThisMonth
            ? Math.round((servicesThisMonth / plan.max_services_per_month) * 100)
            : 0,
      },
      payments: {
        history: payments || [],
        next: nextPayment,
      },
    });
  } catch (error) {
    logError(FUNCTION_NAME, error);
    return errorResponse(error.message || 'Erro ao consultar status de assinatura');
  }
});
