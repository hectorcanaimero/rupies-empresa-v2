-- =====================================================
-- MIGRATION: Functions PostgreSQL - Sistema de Assinaturas
-- Data: 2025-12-28
-- Descrição: Functions para lógica de negócio do sistema
--            de assinaturas
-- =====================================================

-- =====================================================
-- 1. FUNCTION: check_subscription_status
-- Verifica se usuário tem assinatura ativa e retorna detalhes
-- =====================================================

CREATE OR REPLACE FUNCTION check_subscription_status(p_user_id UUID)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
DECLARE
  v_subscription RECORD;
  v_usage RECORD;
BEGIN
  -- Buscar assinatura ativa ou em trial
  SELECT
    s.id,
    s.status,
    s.billing_cycle,
    s.current_period_start,
    s.current_period_end,
    s.trial_end,
    s.cancel_at_period_end,
    p.id as plan_id,
    p.name as plan_name,
    p.features,
    p.max_services_per_month,
    p.max_contractors_contacted,
    p.priority_support,
    p.featured_listing,
    p.analytics_dashboard
  INTO v_subscription
  FROM subscriptions s
  INNER JOIN subscription_plans p ON p.id = s.plan_id
  WHERE s.user_id = p_user_id
    AND s.status IN ('active', 'trialing')
    AND (s.current_period_end > NOW() OR s.trial_end > NOW())
  ORDER BY s.created_at DESC
  LIMIT 1;

  -- Se não encontrou assinatura ativa
  IF NOT FOUND THEN
    RETURN json_build_object(
      'has_active_subscription', false,
      'is_premium', false,
      'is_trial', false,
      'plan', NULL,
      'features', '[]'::json,
      'usage', NULL,
      'limits', json_build_object(
        'max_services_per_month', 5,
        'max_contractors_contacted', 10,
        'services_remaining', 5,
        'contacts_remaining', 10
      )
    );
  END IF;

  -- Buscar uso do período atual
  SELECT
    services_created,
    contractors_contacted
  INTO v_usage
  FROM subscription_usage
  WHERE subscription_id = v_subscription.id
    AND period_start <= NOW()
    AND period_end >= NOW()
  LIMIT 1;

  -- Se não existe registro de uso, criar um
  IF NOT FOUND THEN
    INSERT INTO subscription_usage (
      subscription_id,
      user_id,
      period_start,
      period_end
    )
    VALUES (
      v_subscription.id,
      p_user_id,
      v_subscription.current_period_start,
      v_subscription.current_period_end
    );

    v_usage.services_created := 0;
    v_usage.contractors_contacted := 0;
  END IF;

  -- Calcular limites restantes
  RETURN json_build_object(
    'has_active_subscription', true,
    'is_premium', true,
    'is_trial', v_subscription.status = 'trialing',
    'trial_end', v_subscription.trial_end,
    'plan', json_build_object(
      'id', v_subscription.plan_id,
      'name', v_subscription.plan_name,
      'billing_cycle', v_subscription.billing_cycle,
      'current_period_start', v_subscription.current_period_start,
      'current_period_end', v_subscription.current_period_end,
      'cancel_at_period_end', v_subscription.cancel_at_period_end
    ),
    'features', v_subscription.features,
    'usage', json_build_object(
      'services_created', COALESCE(v_usage.services_created, 0),
      'contractors_contacted', COALESCE(v_usage.contractors_contacted, 0)
    ),
    'limits', json_build_object(
      'max_services_per_month', v_subscription.max_services_per_month,
      'max_contractors_contacted', v_subscription.max_contractors_contacted,
      'services_remaining', CASE
        WHEN v_subscription.max_services_per_month = -1 THEN -1
        ELSE GREATEST(0, v_subscription.max_services_per_month - COALESCE(v_usage.services_created, 0))
      END,
      'contacts_remaining', CASE
        WHEN v_subscription.max_contractors_contacted = -1 THEN -1
        ELSE GREATEST(0, v_subscription.max_contractors_contacted - COALESCE(v_usage.contractors_contacted, 0))
      END
    ),
    'benefits', json_build_object(
      'priority_support', v_subscription.priority_support,
      'featured_listing', v_subscription.featured_listing,
      'analytics_dashboard', v_subscription.analytics_dashboard
    )
  );
END;
$$;

COMMENT ON FUNCTION check_subscription_status IS
  'Verifica status completo da assinatura do usuário incluindo limites e uso';

-- =====================================================
-- 2. FUNCTION: has_premium_feature
-- Verifica se usuário tem acesso a uma feature específica
-- =====================================================

CREATE OR REPLACE FUNCTION has_premium_feature(
  p_user_id UUID,
  p_feature_key TEXT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
STABLE
AS $$
DECLARE
  v_show_premium BOOLEAN;
  v_has_feature BOOLEAN;
BEGIN
  -- Verificar feature flag global
  -- Se show_premium_features = false, sempre retorna true (modo free para stores)
  SELECT is_enabled INTO v_show_premium
  FROM feature_flags
  WHERE flag_key = 'show_premium_features';

  IF v_show_premium IS NULL OR v_show_premium = false THEN
    -- Modo "free" - todas as features liberadas
    RETURN true;
  END IF;

  -- Verificar se usuário tem assinatura ativa com a feature
  SELECT EXISTS(
    SELECT 1
    FROM subscriptions s
    INNER JOIN subscription_plans p ON p.id = s.plan_id
    WHERE s.user_id = p_user_id
      AND s.status IN ('active', 'trialing')
      AND (s.current_period_end > NOW() OR s.trial_end > NOW())
      AND (
        p.features ? p_feature_key  -- Operador JSONB contains
        OR p_feature_key = 'basic_access'  -- Feature básica sempre disponível
      )
  ) INTO v_has_feature;

  RETURN v_has_feature;
END;
$$;

COMMENT ON FUNCTION has_premium_feature IS
  'Verifica se usuário tem acesso a feature premium específica. Respeita feature flag global.';

-- =====================================================
-- 3. FUNCTION: can_create_service
-- Verifica se usuário pode criar mais um serviço
-- =====================================================

CREATE OR REPLACE FUNCTION can_create_service(p_user_id UUID)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_subscription RECORD;
  v_usage RECORD;
  v_can_create BOOLEAN;
  v_reason TEXT;
BEGIN
  -- Buscar assinatura e uso
  SELECT
    s.id as subscription_id,
    s.status,
    p.max_services_per_month
  INTO v_subscription
  FROM subscriptions s
  INNER JOIN subscription_plans p ON p.id = s.plan_id
  WHERE s.user_id = p_user_id
    AND s.status IN ('active', 'trialing')
    AND (s.current_period_end > NOW() OR s.trial_end > NOW())
  ORDER BY s.created_at DESC
  LIMIT 1;

  -- Se não tem assinatura, verificar limite free
  IF NOT FOUND THEN
    SELECT COUNT(*) INTO v_usage
    FROM services
    WHERE userId = p_user_id
      AND created_at >= DATE_TRUNC('month', NOW());

    IF v_usage.count >= 5 THEN
      RETURN json_build_object(
        'can_create', false,
        'reason', 'Limite de 5 serviços/mês atingido. Assine o Clube dos 100 para serviços ilimitados!',
        'current_count', v_usage.count,
        'limit', 5,
        'is_premium', false
      );
    END IF;

    RETURN json_build_object(
      'can_create', true,
      'reason', NULL,
      'current_count', v_usage.count,
      'limit', 5,
      'is_premium', false
    );
  END IF;

  -- Tem assinatura - verificar limite
  SELECT services_created
  INTO v_usage
  FROM subscription_usage
  WHERE subscription_id = v_subscription.subscription_id
    AND period_start <= NOW()
    AND period_end >= NOW()
  LIMIT 1;

  -- Ilimitado
  IF v_subscription.max_services_per_month = -1 THEN
    RETURN json_build_object(
      'can_create', true,
      'reason', NULL,
      'current_count', COALESCE(v_usage.services_created, 0),
      'limit', -1,
      'is_premium', true
    );
  END IF;

  -- Verificar limite
  IF COALESCE(v_usage.services_created, 0) >= v_subscription.max_services_per_month THEN
    RETURN json_build_object(
      'can_create', false,
      'reason', format('Limite de %s serviços/mês atingido', v_subscription.max_services_per_month),
      'current_count', v_usage.services_created,
      'limit', v_subscription.max_services_per_month,
      'is_premium', true
    );
  END IF;

  RETURN json_build_object(
    'can_create', true,
    'reason', NULL,
    'current_count', COALESCE(v_usage.services_created, 0),
    'limit', v_subscription.max_services_per_month,
    'is_premium', true
  );
END;
$$;

COMMENT ON FUNCTION can_create_service IS
  'Verifica se usuário pode criar mais um serviço baseado em seu plano';

-- =====================================================
-- 4. FUNCTION: increment_service_usage
-- Incrementa contador de serviços criados
-- =====================================================

CREATE OR REPLACE FUNCTION increment_service_usage(p_user_id UUID)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_subscription_id UUID;
  v_period_start TIMESTAMPTZ;
  v_period_end TIMESTAMPTZ;
BEGIN
  -- Buscar assinatura ativa
  SELECT
    s.id,
    s.current_period_start,
    s.current_period_end
  INTO
    v_subscription_id,
    v_period_start,
    v_period_end
  FROM subscriptions s
  WHERE s.user_id = p_user_id
    AND s.status IN ('active', 'trialing')
    AND (s.current_period_end > NOW() OR s.trial_end > NOW())
  ORDER BY s.created_at DESC
  LIMIT 1;

  -- Se não tem assinatura, não fazer nada
  IF NOT FOUND THEN
    RETURN;
  END IF;

  -- Incrementar ou criar registro de uso
  INSERT INTO subscription_usage (
    subscription_id,
    user_id,
    period_start,
    period_end,
    services_created
  )
  VALUES (
    v_subscription_id,
    p_user_id,
    v_period_start,
    v_period_end,
    1
  )
  ON CONFLICT ON CONSTRAINT no_overlap
  DO UPDATE SET
    services_created = subscription_usage.services_created + 1,
    updated_at = NOW();
END;
$$;

COMMENT ON FUNCTION increment_service_usage IS
  'Incrementa contador de serviços criados no período atual';

-- =====================================================
-- 5. FUNCTION: process_asaas_webhook
-- Processa webhooks do Asaas
-- =====================================================

CREATE OR REPLACE FUNCTION process_asaas_webhook(
  p_event_type TEXT,
  p_payment_data JSONB
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_asaas_payment_id TEXT;
  v_status TEXT;
  v_subscription_id UUID;
  v_payment_date TIMESTAMPTZ;
BEGIN
  v_asaas_payment_id := p_payment_data->>'id';
  v_status := p_payment_data->>'status';

  -- Mapear status Asaas para nosso sistema
  v_status := CASE v_status
    WHEN 'RECEIVED' THEN 'received'
    WHEN 'CONFIRMED' THEN 'confirmed'
    WHEN 'PENDING' THEN 'pending'
    WHEN 'OVERDUE' THEN 'overdue'
    WHEN 'REFUNDED' THEN 'refunded'
    ELSE 'pending'
  END;

  -- Atualizar transação existente
  UPDATE payment_transactions
  SET
    status = v_status,
    payment_date = CASE
      WHEN v_status IN ('received', 'confirmed') THEN NOW()
      ELSE payment_date
    END,
    invoice_url = COALESCE(p_payment_data->>'invoiceUrl', invoice_url),
    error_message = COALESCE(p_payment_data->>'description', error_message),
    metadata = p_payment_data,
    updated_at = NOW()
  WHERE asaas_payment_id = v_asaas_payment_id
  RETURNING subscription_id, payment_date INTO v_subscription_id, v_payment_date;

  -- Se não encontrou, criar nova transação
  IF NOT FOUND THEN
    -- Buscar subscription_id pelo asaas_subscription_id
    SELECT id INTO v_subscription_id
    FROM subscriptions
    WHERE asaas_subscription_id = p_payment_data->>'subscription';

    IF FOUND THEN
      INSERT INTO payment_transactions (
        subscription_id,
        user_id,
        asaas_payment_id,
        amount,
        status,
        payment_method,
        invoice_url,
        metadata
      )
      SELECT
        v_subscription_id,
        s.user_id,
        v_asaas_payment_id,
        (p_payment_data->>'value')::DECIMAL,
        v_status,
        LOWER(p_payment_data->>'billingType'),
        p_payment_data->>'invoiceUrl',
        p_payment_data
      FROM subscriptions s
      WHERE s.id = v_subscription_id;
    END IF;
  END IF;

  -- Atualizar status da assinatura baseado no pagamento
  IF v_subscription_id IS NOT NULL THEN
    IF v_status IN ('received', 'confirmed') THEN
      -- Pagamento confirmado - ativar assinatura
      UPDATE subscriptions
      SET
        status = 'active',
        updated_at = NOW()
      WHERE id = v_subscription_id
        AND status IN ('pending', 'past_due');

    ELSIF v_status = 'overdue' THEN
      -- Pagamento vencido - marcar como atrasado
      UPDATE subscriptions
      SET
        status = 'past_due',
        updated_at = NOW()
      WHERE id = v_subscription_id
        AND status = 'active';
    END IF;
  END IF;

  RETURN json_build_object(
    'success', true,
    'event_type', p_event_type,
    'status', v_status,
    'subscription_id', v_subscription_id,
    'processed_at', NOW()
  );
EXCEPTION
  WHEN OTHERS THEN
    -- Log do erro
    RAISE WARNING 'Erro processando webhook Asaas: %', SQLERRM;

    RETURN json_build_object(
      'success', false,
      'error', SQLERRM,
      'event_type', p_event_type
    );
END;
$$;

COMMENT ON FUNCTION process_asaas_webhook IS
  'Processa webhooks do Asaas atualizando status de pagamentos e assinaturas';

-- =====================================================
-- 6. FUNCTION: cancel_subscription
-- Cancela assinatura (no fim do período ou imediatamente)
-- =====================================================

CREATE OR REPLACE FUNCTION cancel_subscription(
  p_subscription_id UUID,
  p_immediate BOOLEAN DEFAULT false
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_subscription RECORD;
BEGIN
  -- Buscar assinatura
  SELECT * INTO v_subscription
  FROM subscriptions
  WHERE id = p_subscription_id;

  IF NOT FOUND THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Assinatura não encontrada'
    );
  END IF;

  -- Verificar se já está cancelada
  IF v_subscription.status = 'canceled' THEN
    RETURN json_build_object(
      'success', false,
      'error', 'Assinatura já está cancelada'
    );
  END IF;

  -- Cancelamento imediato
  IF p_immediate THEN
    UPDATE subscriptions
    SET
      status = 'canceled',
      canceled_at = NOW(),
      cancel_at_period_end = false,
      current_period_end = NOW(),
      updated_at = NOW()
    WHERE id = p_subscription_id;

    RETURN json_build_object(
      'success', true,
      'message', 'Assinatura cancelada imediatamente',
      'canceled_at', NOW()
    );
  END IF;

  -- Cancelamento no fim do período
  UPDATE subscriptions
  SET
    cancel_at_period_end = true,
    canceled_at = NOW(),
    updated_at = NOW()
  WHERE id = p_subscription_id;

  RETURN json_build_object(
    'success', true,
    'message', 'Assinatura será cancelada no fim do período',
    'canceled_at', NOW(),
    'active_until', v_subscription.current_period_end
  );
END;
$$;

COMMENT ON FUNCTION cancel_subscription IS
  'Cancela assinatura imediatamente ou no fim do período';

-- =====================================================
-- FIM DAS FUNCTIONS
-- =====================================================
