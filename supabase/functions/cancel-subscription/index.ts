/**
 * Edge Function: cancel-subscription
 *
 * Cancela uma assinatura ativa do usuário
 *
 * Comportamentos:
 * - Se immediate=true: cancela imediatamente e remove acesso
 * - Se immediate=false (padrão): cancela ao fim do período atual (cancel_at_period_end)
 *
 * Requisição:
 * POST /functions/v1/cancel-subscription
 * Authorization: Bearer <user-jwt-token>
 * Body:
 * {
 *   "subscriptionId": "uuid",
 *   "immediate": false,  // opcional, padrão: false
 *   "reason": "string"   // opcional
 * }
 *
 * Resposta:
 * {
 *   "success": true,
 *   "data": {
 *     "subscription": { ... },
 *     "canceledAt": "2024-01-01T00:00:00Z",
 *     "immediate": false,
 *     "endsAt": "2024-02-01T00:00:00Z"
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
import { cancelAsaasSubscription } from '../_shared/asaas-api.ts';

const FUNCTION_NAME = 'cancel-subscription';

serve(async (req: Request) => {
  try {
    logInfo(FUNCTION_NAME, 'Iniciando cancelamento de assinatura');

    // 1. Criar cliente Supabase
    const supabase = createServiceClient();

    // 2. Obter usuário autenticado
    const user = await getAuthenticatedUser(req, supabase);
    logInfo(FUNCTION_NAME, 'Usuário autenticado', { userId: user.id });

    // 3. Parse do body
    const body = await req.json();
    validateRequiredFields(body, ['subscriptionId']);

    const { subscriptionId, immediate = false, reason = null } = body;

    // 4. Buscar assinatura no banco
    const { data: subscription, error: fetchError } = await supabase
      .from('subscriptions')
      .select('*')
      .eq('id', subscriptionId)
      .eq('user_id', user.id) // Garantir que usuário só cancele sua própria assinatura
      .single();

    if (fetchError || !subscription) {
      throw new Error('Assinatura não encontrada ou acesso negado');
    }

    logInfo(FUNCTION_NAME, 'Assinatura encontrada', {
      subscriptionId: subscription.id,
      status: subscription.status,
      asaasSubscriptionId: subscription.asaas_subscription_id,
    });

    // 5. Validar se assinatura pode ser cancelada
    if (subscription.status === 'canceled') {
      throw new Error('Assinatura já está cancelada');
    }

    if (subscription.status === 'expired') {
      throw new Error('Assinatura já expirou');
    }

    // 6. Cancelar no Asaas (se houver ID Asaas)
    if (subscription.asaas_subscription_id) {
      try {
        await cancelAsaasSubscription(subscription.asaas_subscription_id);
        logInfo(FUNCTION_NAME, 'Assinatura cancelada no Asaas', {
          asaasSubscriptionId: subscription.asaas_subscription_id,
        });
      } catch (error) {
        logError(FUNCTION_NAME, error);
        // Continuar mesmo se falhar no Asaas
        // Vamos cancelar localmente de qualquer forma
        logInfo(FUNCTION_NAME, 'Continuando cancelamento local apesar de erro no Asaas');
      }
    }

    // 7. Atualizar assinatura no banco local
    const now = new Date();
    let updateData: any;

    if (immediate) {
      // Cancelamento imediato
      updateData = {
        status: 'canceled',
        canceled_at: now.toISOString(),
        current_period_end: now.toISOString(), // Termina agora
        cancel_at_period_end: false,
        metadata: {
          ...subscription.metadata,
          cancel_reason: reason,
          canceled_by: user.id,
          canceled_via: 'edge_function',
        },
        updated_at: now.toISOString(),
      };

      logInfo(FUNCTION_NAME, 'Cancelamento imediato aplicado');
    } else {
      // Cancelamento ao fim do período
      updateData = {
        cancel_at_period_end: true,
        canceled_at: now.toISOString(),
        metadata: {
          ...subscription.metadata,
          cancel_reason: reason,
          canceled_by: user.id,
          canceled_via: 'edge_function',
        },
        updated_at: now.toISOString(),
      };

      logInfo(FUNCTION_NAME, 'Cancelamento agendado para fim do período', {
        endsAt: subscription.current_period_end,
      });
    }

    const { data: updatedSubscription, error: updateError } = await supabase
      .from('subscriptions')
      .update(updateData)
      .eq('id', subscriptionId)
      .select()
      .single();

    if (updateError) {
      logError(FUNCTION_NAME, updateError);
      throw new Error('Erro ao atualizar assinatura no banco de dados');
    }

    logInfo(FUNCTION_NAME, 'Assinatura atualizada com sucesso', {
      subscriptionId: updatedSubscription.id,
      status: updatedSubscription.status,
      cancelAtPeriodEnd: updatedSubscription.cancel_at_period_end,
    });

    // 8. Se cancelamento imediato, marcar transações pendentes como canceladas
    if (immediate) {
      const { error: transactionsError } = await supabase
        .from('payment_transactions')
        .update({
          status: 'canceled',
          error_message: 'Assinatura cancelada pelo usuário',
          updated_at: now.toISOString(),
        })
        .eq('subscription_id', subscriptionId)
        .eq('status', 'pending');

      if (transactionsError) {
        logError(FUNCTION_NAME, transactionsError);
        // Não falhar, apenas logar
      } else {
        logInfo(FUNCTION_NAME, 'Transações pendentes canceladas');
      }
    }

    // 9. Retornar resposta de sucesso
    return successResponse({
      subscription: updatedSubscription,
      canceledAt: updatedSubscription.canceled_at,
      immediate,
      endsAt: updatedSubscription.current_period_end,
      message: immediate
        ? 'Assinatura cancelada imediatamente'
        : 'Assinatura será cancelada ao fim do período atual',
    });
  } catch (error) {
    logError(FUNCTION_NAME, error);
    return errorResponse(error.message || 'Erro ao cancelar assinatura');
  }
});
