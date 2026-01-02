-- ═══════════════════════════════════════════════════════════════════════════
-- MIGRATION COMPLETA - Sistema Clube dos 100
-- ═══════════════════════════════════════════════════════════════════════════
--
-- VERSIÓN: 3.1 (CORREGIDO - user_id UUID + isContractor quoted)
--
-- PASOS:
-- 1. Abrir: https://supa.rupies.com.br → SQL Editor
-- 2. Copiar TODO este archivo
-- 3. Pegar en SQL Editor
-- 4. Click "Run"
--
-- ═══════════════════════════════════════════════════════════════════════════

DROP TABLE IF EXISTS subscriptions CASCADE;

-- =====================================================
-- MIGRATION: Sistema de Assinaturas - Clube dos 100
-- Data: 2025-12-28
-- Versão: 2 (Corrigido para user_id TEXT)
-- Descrição: Cria tabelas, functions, views e policies
--            para sistema de assinaturas com Asaas
-- =====================================================

-- Habilitar extensão UUID se não existir
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "btree_gist";  -- Para constraint no_overlap

-- =====================================================
-- 1. TABELA: subscription_plans
-- =====================================================

CREATE TABLE IF NOT EXISTS subscription_plans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  price_monthly DECIMAL(10,2),
  price_yearly DECIMAL(10,2),
  asaas_plan_id TEXT,
  features JSONB NOT NULL DEFAULT '[]'::jsonb,
  max_services_per_month INT DEFAULT -1, -- -1 = ilimitado
  max_contractors_contacted INT DEFAULT -1, -- -1 = ilimitado
  priority_support BOOLEAN DEFAULT false,
  featured_listing BOOLEAN DEFAULT false,
  analytics_dashboard BOOLEAN DEFAULT false,
  is_active BOOLEAN DEFAULT true,
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices para subscription_plans
CREATE INDEX IF NOT EXISTS idx_subscription_plans_active
  ON subscription_plans(is_active)
  WHERE is_active = true;

CREATE INDEX IF NOT EXISTS idx_subscription_plans_sort
  ON subscription_plans(sort_order, created_at);

-- Comentários
COMMENT ON TABLE subscription_plans IS
  'Planos de assinatura disponíveis no Clube dos 100 Rupies';
COMMENT ON COLUMN subscription_plans.features IS
  'Array JSON de features. Ex: ["unlimited_posts", "priority_support", "analytics"]';
COMMENT ON COLUMN subscription_plans.max_services_per_month IS
  'Limite de serviços por mês. -1 = ilimitado';

-- =====================================================
-- 2. TABELA: subscriptions
-- =====================================================

CREATE TABLE IF NOT EXISTS subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  plan_id UUID NOT NULL REFERENCES subscription_plans(id),
  asaas_subscription_id TEXT,
  asaas_customer_id TEXT,
  status TEXT NOT NULL DEFAULT 'pending',
  billing_cycle TEXT NOT NULL CHECK (billing_cycle IN ('monthly', 'yearly')),
  current_period_start TIMESTAMPTZ,
  current_period_end TIMESTAMPTZ,
  cancel_at_period_end BOOLEAN DEFAULT false,
  canceled_at TIMESTAMPTZ,
  trial_start TIMESTAMPTZ,
  trial_end TIMESTAMPTZ,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_status CHECK (
    status IN ('pending', 'active', 'past_due', 'canceled', 'expired', 'trialing')
  ),
  CONSTRAINT valid_period CHECK (
    current_period_end IS NULL OR current_period_end > current_period_start
  )
);

-- Índices para subscriptions
CREATE INDEX IF NOT EXISTS idx_subscriptions_user
  ON subscriptions(user_id);

CREATE INDEX IF NOT EXISTS idx_subscriptions_status
  ON subscriptions(status);

CREATE INDEX IF NOT EXISTS idx_subscriptions_asaas
  ON subscriptions(asaas_subscription_id)
  WHERE asaas_subscription_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_subscriptions_period_end
  ON subscriptions(current_period_end)
  WHERE status IN ('active', 'trialing');

-- Índice único: apenas 1 assinatura ativa por usuário
CREATE UNIQUE INDEX IF NOT EXISTS idx_subscriptions_active_user
  ON subscriptions(user_id)
  WHERE status IN ('active', 'trialing');

-- Comentários
COMMENT ON TABLE subscriptions IS
  'Assinaturas dos usuários empresas no Clube dos 100';
COMMENT ON COLUMN subscriptions.status IS
  'Status: pending, active, past_due, canceled, expired, trialing';
COMMENT ON COLUMN subscriptions.billing_cycle IS
  'Ciclo de cobrança: monthly ou yearly';

-- =====================================================
-- 3. TABELA: payment_transactions
-- =====================================================

CREATE TABLE IF NOT EXISTS payment_transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  subscription_id UUID REFERENCES subscriptions(id) ON DELETE SET NULL,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  asaas_payment_id TEXT,
  amount DECIMAL(10,2) NOT NULL,
  currency TEXT DEFAULT 'BRL',
  status TEXT NOT NULL,
  payment_method TEXT,
  due_date DATE,
  payment_date TIMESTAMPTZ,
  invoice_url TEXT,
  pix_qr_code_url TEXT,
  pix_copy_paste TEXT,
  boleto_bar_code TEXT,
  error_code TEXT,
  error_message TEXT,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_payment_status CHECK (
    status IN ('pending', 'confirmed', 'received', 'overdue', 'refunded', 'canceled')
  ),
  CONSTRAINT valid_payment_method CHECK (
    payment_method IS NULL OR
    payment_method IN ('credit_card', 'boleto', 'pix', 'debit_card')
  ),
  CONSTRAINT positive_amount CHECK (amount > 0)
);

-- Índices para payment_transactions
CREATE INDEX IF NOT EXISTS idx_payment_transactions_subscription
  ON payment_transactions(subscription_id);

CREATE INDEX IF NOT EXISTS idx_payment_transactions_user
  ON payment_transactions(user_id);

CREATE INDEX IF NOT EXISTS idx_payment_transactions_status
  ON payment_transactions(status);

CREATE INDEX IF NOT EXISTS idx_payment_transactions_asaas
  ON payment_transactions(asaas_payment_id)
  WHERE asaas_payment_id IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_payment_transactions_date
  ON payment_transactions(created_at DESC);

-- Comentários
COMMENT ON TABLE payment_transactions IS
  'Histórico de transações de pagamento via Asaas';
COMMENT ON COLUMN payment_transactions.status IS
  'Status: pending, confirmed, received, overdue, refunded, canceled';

-- =====================================================
-- 4. TABELA: feature_flags
-- =====================================================

CREATE TABLE IF NOT EXISTS feature_flags (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  flag_key TEXT NOT NULL UNIQUE,
  description TEXT,
  is_enabled BOOLEAN DEFAULT false,
  target_audience TEXT DEFAULT 'all',
  rollout_percentage INT DEFAULT 100,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Constraints
  CONSTRAINT valid_target_audience CHECK (
    target_audience IN ('all', 'premium', 'free', 'beta_users')
  ),
  CONSTRAINT valid_rollout CHECK (
    rollout_percentage >= 0 AND rollout_percentage <= 100
  )
);

-- Índice para feature_flags
CREATE INDEX IF NOT EXISTS idx_feature_flags_key
  ON feature_flags(flag_key);

CREATE INDEX IF NOT EXISTS idx_feature_flags_enabled
  ON feature_flags(is_enabled)
  WHERE is_enabled = true;

-- Comentários
COMMENT ON TABLE feature_flags IS
  'Feature flags para controle de funcionalidades no app';
COMMENT ON COLUMN feature_flags.rollout_percentage IS
  'Percentual de usuários que veem a feature (0-100)';

-- =====================================================
-- 5. TABELA: subscription_usage (Tracking de uso)
-- =====================================================

CREATE TABLE IF NOT EXISTS subscription_usage (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  subscription_id UUID NOT NULL REFERENCES subscriptions(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  period_start TIMESTAMPTZ NOT NULL,
  period_end TIMESTAMPTZ NOT NULL,
  services_created INT DEFAULT 0,
  contractors_contacted INT DEFAULT 0,
  candidates_received INT DEFAULT 0,
  metadata JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Constraint: não permitir períodos sobrepostos para mesmo usuário
  CONSTRAINT no_overlap EXCLUDE USING gist (
    user_id WITH =,
    tstzrange(period_start, period_end) WITH &&
  )
);

-- Índices para subscription_usage
CREATE INDEX IF NOT EXISTS idx_subscription_usage_subscription
  ON subscription_usage(subscription_id);

CREATE INDEX IF NOT EXISTS idx_subscription_usage_user
  ON subscription_usage(user_id);

CREATE INDEX IF NOT EXISTS idx_subscription_usage_period
  ON subscription_usage(period_start, period_end);

-- Comentários
COMMENT ON TABLE subscription_usage IS
  'Tracking de uso mensal para cada assinatura';

-- =====================================================
-- 6. TRIGGER: Updated_at automático
-- =====================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar trigger em todas as tabelas
CREATE TRIGGER update_subscription_plans_updated_at
  BEFORE UPDATE ON subscription_plans
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_subscriptions_updated_at
  BEFORE UPDATE ON subscriptions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payment_transactions_updated_at
  BEFORE UPDATE ON payment_transactions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_feature_flags_updated_at
  BEFORE UPDATE ON feature_flags
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_subscription_usage_updated_at
  BEFORE UPDATE ON subscription_usage
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 7. RLS (Row Level Security) POLICIES
-- =====================================================

-- Habilitar RLS
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE subscription_usage ENABLE ROW LEVEL SECURITY;

-- Policies para subscriptions
CREATE POLICY "Usuários podem ver próprias assinaturas"
  ON subscriptions FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Usuários podem criar próprias assinaturas"
  ON subscriptions FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Usuários podem atualizar próprias assinaturas"
  ON subscriptions FOR UPDATE
  USING (auth.uid() = user_id);

-- Policies para payment_transactions
CREATE POLICY "Usuários podem ver próprias transações"
  ON payment_transactions FOR SELECT
  USING (auth.uid() = user_id);

-- Policies para subscription_usage
CREATE POLICY "Usuários podem ver próprio uso"
  ON subscription_usage FOR SELECT
  USING (auth.uid() = user_id);

-- subscription_plans e feature_flags são públicos (SELECT only)
ALTER TABLE subscription_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE feature_flags ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Planos são públicos"
  ON subscription_plans FOR SELECT
  USING (is_active = true);

CREATE POLICY "Feature flags são públicos"
  ON feature_flags FOR SELECT
  TO authenticated
  USING (true);

-- =====================================================
-- 8. DADOS INICIAIS
-- =====================================================

-- Inserir feature flag principal
INSERT INTO feature_flags (flag_key, description, is_enabled, metadata)
VALUES (
  'show_premium_features',
  'Controla se features premium são visíveis no app (para lançamento na loja)',
  false,  -- Desabilitado por padrão para aprovação nas stores
  jsonb_build_object(
    'controlled_features', jsonb_build_array(
      'subscription_screen',
      'premium_badge',
      'upgrade_prompts',
      'analytics_dashboard'
    ),
    'enable_after_store_approval', true
  )
)
ON CONFLICT (flag_key) DO NOTHING;

-- Inserir plano FREE (default)
INSERT INTO subscription_plans (
  name,
  description,
  price_monthly,
  price_yearly,
  features,
  max_services_per_month,
  max_contractors_contacted,
  priority_support,
  featured_listing,
  analytics_dashboard,
  is_active,
  sort_order
)
VALUES (
  'Grátis',
  'Plano básico para começar',
  0.00,
  0.00,
  '["basic_posting", "basic_search"]'::jsonb,
  5,    -- 5 serviços por mês
  10,   -- 10 contatos por mês
  false,
  false,
  false,
  true,
  1
)
ON CONFLICT DO NOTHING;

-- Inserir plano CLUBE DOS 100 - Mensal
INSERT INTO subscription_plans (
  name,
  description,
  price_monthly,
  price_yearly,
  features,
  max_services_per_month,
  max_contractors_contacted,
  priority_support,
  featured_listing,
  analytics_dashboard,
  is_active,
  sort_order
)
VALUES (
  'Clube dos 100 - Mensal',
  'Acesso completo a todos os recursos premium',
  99.90,
  NULL,
  '["unlimited_posts", "unlimited_contacts", "priority_support", "analytics", "featured_listing", "advanced_filters"]'::jsonb,
  -1,   -- Ilimitado
  -1,   -- Ilimitado
  true,
  true,
  true,
  true,
  2
)
ON CONFLICT DO NOTHING;

-- Inserir plano CLUBE DOS 100 - Anual (com desconto)
INSERT INTO subscription_plans (
  name,
  description,
  price_monthly,
  price_yearly,
  features,
  max_services_per_month,
  max_contractors_contacted,
  priority_support,
  featured_listing,
  analytics_dashboard,
  is_active,
  sort_order
)
VALUES (
  'Clube dos 100 - Anual',
  'Acesso completo com 20% de desconto (R$ 959,04/ano)',
  NULL,
  959.04,  -- Equivalente a ~R$ 79,92/mês (20% desconto)
  '["unlimited_posts", "unlimited_contacts", "priority_support", "analytics", "featured_listing", "advanced_filters", "annual_discount"]'::jsonb,
  -1,   -- Ilimitado
  -1,   -- Ilimitado
  true,
  true,
  true,
  true,
  3
)
ON CONFLICT DO NOTHING;

-- =====================================================
-- FIM DA MIGRATION
-- =====================================================

-- Registrar migration
COMMENT ON SCHEMA public IS 'Sistema de assinaturas Clube dos 100 criado em 2025-12-28';
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
-- =====================================================
-- MIGRATION: Views - Sistema de Assinaturas
-- Data: 2025-12-28
-- Descrição: Views otimizadas para queries comuns
-- =====================================================

-- =====================================================
-- 1. VIEW: view_active_subscriptions
-- Assinaturas ativas com detalhes do plano e usuário
-- =====================================================

CREATE OR REPLACE VIEW view_active_subscriptions AS
SELECT
  s.id AS subscription_id,
  s.user_id,
  u.email AS user_email,
  u.display_name AS user_name,
  u.name_contractor,
  u.cpfcnpj,
  s.status AS subscription_status,
  s.billing_cycle,
  s.current_period_start,
  s.current_period_end,
  s.trial_end,
  s.cancel_at_period_end,
  s.canceled_at,
  s.created_at AS subscription_created_at,
  p.id AS plan_id,
  p.name AS plan_name,
  p.price_monthly,
  p.price_yearly,
  p.features,
  p.max_services_per_month,
  p.max_contractors_contacted,
  p.priority_support,
  p.featured_listing,
  p.analytics_dashboard,
  -- Campos calculados
  CASE
    WHEN s.status = 'trialing' THEN 'Trial'
    WHEN s.cancel_at_period_end THEN 'Cancelando'
    WHEN s.status = 'active' THEN 'Ativo'
    WHEN s.status = 'past_due' THEN 'Atrasado'
    ELSE 'Outro'
  END AS status_display,
  CASE
    WHEN s.trial_end > NOW() THEN s.trial_end
    ELSE s.current_period_end
  END AS expires_at,
  CASE
    WHEN s.billing_cycle = 'yearly' THEN p.price_yearly
    ELSE p.price_monthly
  END AS current_price
FROM subscriptions s
INNER JOIN subscription_plans p ON p.id = s.plan_id
INNER JOIN users u ON u.id = s.user_id
WHERE s.status IN ('active', 'trialing', 'past_due')
ORDER BY s.created_at DESC;

COMMENT ON VIEW view_active_subscriptions IS
  'Todas as assinaturas ativas/trial com informações do usuário e plano';

-- =====================================================
-- 2. VIEW: view_subscription_metrics
-- Métricas gerais do sistema de assinaturas
-- =====================================================

CREATE OR REPLACE VIEW view_subscription_metrics AS
SELECT
  -- Contagens por status
  COUNT(*) FILTER (WHERE status = 'active') AS total_active,
  COUNT(*) FILTER (WHERE status = 'trialing') AS total_trialing,
  COUNT(*) FILTER (WHERE status = 'past_due') AS total_past_due,
  COUNT(*) FILTER (WHERE status = 'canceled') AS total_canceled,
  COUNT(*) FILTER (WHERE status = 'pending') AS total_pending,

  -- MRR (Monthly Recurring Revenue)
  SUM(
    CASE
      WHEN s.status IN ('active', 'trialing') AND s.billing_cycle = 'monthly' THEN p.price_monthly
      WHEN s.status IN ('active', 'trialing') AND s.billing_cycle = 'yearly' THEN p.price_yearly / 12
      ELSE 0
    END
  ) AS mrr,

  -- ARR (Annual Recurring Revenue)
  SUM(
    CASE
      WHEN s.status IN ('active', 'trialing') AND s.billing_cycle = 'monthly' THEN p.price_monthly * 12
      WHEN s.status IN ('active', 'trialing') AND s.billing_cycle = 'yearly' THEN p.price_yearly
      ELSE 0
    END
  ) AS arr,

  -- Contagens por ciclo de cobrança
  COUNT(*) FILTER (WHERE billing_cycle = 'monthly' AND status IN ('active', 'trialing')) AS monthly_subscriptions,
  COUNT(*) FILTER (WHERE billing_cycle = 'yearly' AND status IN ('active', 'trialing')) AS yearly_subscriptions,

  -- Cancelamentos
  COUNT(*) FILTER (WHERE cancel_at_period_end = true) AS pending_cancellations,
  COUNT(*) FILTER (WHERE canceled_at >= NOW() - INTERVAL '30 days') AS canceled_last_30_days,

  -- Trial
  COUNT(*) FILTER (WHERE status = 'trialing' AND trial_end > NOW()) AS active_trials,
  COUNT(*) FILTER (WHERE status = 'trialing' AND trial_end <= NOW()) AS expired_trials

FROM subscriptions s
INNER JOIN subscription_plans p ON p.id = s.plan_id;

COMMENT ON VIEW view_subscription_metrics IS
  'Métricas agregadas do sistema de assinaturas (MRR, ARR, contagens)';

-- =====================================================
-- 3. VIEW: view_user_subscription_summary
-- Resumo da assinatura por usuário (para o app)
-- =====================================================

CREATE OR REPLACE VIEW view_user_subscription_summary AS
SELECT
  u.id AS user_id,
  u.email,
  u.display_name,

  -- Assinatura atual
  s.id AS subscription_id,
  s.status AS subscription_status,
  p.name AS plan_name,
  p.features,

  -- Limites
  p.max_services_per_month,
  p.max_contractors_contacted,

  -- Uso atual
  COALESCE(usage.services_created, 0) AS services_used_this_month,
  COALESCE(usage.contractors_contacted, 0) AS contractors_contacted_this_month,

  -- Restante
  CASE
    WHEN p.max_services_per_month = -1 THEN -1
    ELSE GREATEST(0, p.max_services_per_month - COALESCE(usage.services_created, 0))
  END AS services_remaining,

  CASE
    WHEN p.max_contractors_contacted = -1 THEN -1
    ELSE GREATEST(0, p.max_contractors_contacted - COALESCE(usage.contractors_contacted, 0))
  END AS contacts_remaining,

  -- Benefícios
  p.priority_support,
  p.featured_listing,
  p.analytics_dashboard,

  -- Período
  s.current_period_start,
  s.current_period_end,
  s.trial_end,
  s.cancel_at_period_end,

  -- Flags
  CASE WHEN s.status IN ('active', 'trialing') THEN true ELSE false END AS is_premium,
  CASE WHEN s.status = 'trialing' THEN true ELSE false END AS is_trial,
  CASE WHEN s.status = 'past_due' THEN true ELSE false END AS payment_failed

FROM users u
LEFT JOIN subscriptions s ON s.user_id = u.id
  AND s.status IN ('active', 'trialing', 'past_due')
  AND (s.current_period_end > NOW() OR s.trial_end > NOW())
LEFT JOIN subscription_plans p ON p.id = s.plan_id
LEFT JOIN subscription_usage usage ON usage.subscription_id = s.id
  AND usage.period_start <= NOW()
  AND usage.period_end >= NOW()
WHERE u."isContractor" = true  -- Apenas empresas
ORDER BY u.created_at DESC;

COMMENT ON VIEW view_user_subscription_summary IS
  'Resumo completo da assinatura por usuário (usado no app)';

-- =====================================================
-- 4. VIEW: view_payment_history
-- Histórico de pagamentos com detalhes
-- =====================================================

CREATE OR REPLACE VIEW view_payment_history AS
SELECT
  pt.id AS transaction_id,
  pt.user_id,
  u.email AS user_email,
  u.display_name AS user_name,
  pt.amount,
  pt.currency,
  pt.status AS payment_status,
  pt.payment_method,
  pt.due_date,
  pt.payment_date,
  pt.invoice_url,
  pt.pix_qr_code_url,
  pt.pix_copy_paste,
  pt.boleto_bar_code,
  pt.error_message,
  pt.created_at AS transaction_created_at,
  s.id AS subscription_id,
  p.name AS plan_name,
  s.billing_cycle,
  -- Status display
  CASE pt.status
    WHEN 'pending' THEN 'Pendente'
    WHEN 'confirmed' THEN 'Confirmado'
    WHEN 'received' THEN 'Recebido'
    WHEN 'overdue' THEN 'Vencido'
    WHEN 'refunded' THEN 'Reembolsado'
    WHEN 'canceled' THEN 'Cancelado'
    ELSE 'Outro'
  END AS status_display,
  -- Dias até vencimento
  CASE
    WHEN pt.due_date IS NOT NULL AND pt.status = 'pending' THEN
      pt.due_date - CURRENT_DATE
    ELSE NULL
  END AS days_until_due
FROM payment_transactions pt
INNER JOIN users u ON u.id = pt.user_id
LEFT JOIN subscriptions s ON s.id = pt.subscription_id
LEFT JOIN subscription_plans p ON p.id = s.plan_id
ORDER BY pt.created_at DESC;

COMMENT ON VIEW view_payment_history IS
  'Histórico completo de pagamentos com detalhes do usuário e plano';

-- =====================================================
-- 5. VIEW: view_churned_subscriptions
-- Assinaturas canceladas (churn analysis)
-- =====================================================

CREATE OR REPLACE VIEW view_churned_subscriptions AS
SELECT
  s.id AS subscription_id,
  s.user_id,
  u.email AS user_email,
  u.display_name AS user_name,
  p.name AS plan_name,
  s.billing_cycle,
  s.created_at AS subscription_started,
  s.canceled_at,
  s.updated_at AS subscription_ended,
  -- Duração da assinatura
  EXTRACT(EPOCH FROM (s.updated_at - s.created_at)) / 86400 AS days_subscribed,
  -- Lifetime value
  CASE
    WHEN s.billing_cycle = 'monthly' THEN
      p.price_monthly * (EXTRACT(EPOCH FROM (s.updated_at - s.created_at)) / 2592000) -- aprox meses
    WHEN s.billing_cycle = 'yearly' THEN
      p.price_yearly
    ELSE 0
  END AS estimated_ltv,
  -- Razão do cancelamento (se tiver em metadata)
  s.metadata->>'cancellation_reason' AS cancellation_reason,
  s.metadata->>'cancellation_feedback' AS cancellation_feedback
FROM subscriptions s
INNER JOIN users u ON u.id = s.user_id
INNER JOIN subscription_plans p ON p.id = s.plan_id
WHERE s.status = 'canceled'
ORDER BY s.canceled_at DESC;

COMMENT ON VIEW view_churned_subscriptions IS
  'Assinaturas canceladas para análise de churn';

-- =====================================================
-- 6. VIEW: view_trial_conversions
-- Conversão de trials para assinaturas pagas
-- =====================================================

CREATE OR REPLACE VIEW view_trial_conversions AS
SELECT
  DATE_TRUNC('month', s.created_at) AS month,
  COUNT(*) FILTER (WHERE s.trial_start IS NOT NULL) AS total_trials,
  COUNT(*) FILTER (WHERE s.trial_start IS NOT NULL AND s.status = 'active') AS converted_trials,
  COUNT(*) FILTER (WHERE s.trial_start IS NOT NULL AND s.status = 'canceled') AS canceled_trials,
  ROUND(
    100.0 * COUNT(*) FILTER (WHERE s.trial_start IS NOT NULL AND s.status = 'active') /
    NULLIF(COUNT(*) FILTER (WHERE s.trial_start IS NOT NULL), 0),
    2
  ) AS conversion_rate
FROM subscriptions s
WHERE s.trial_start IS NOT NULL
GROUP BY DATE_TRUNC('month', s.created_at)
ORDER BY month DESC;

COMMENT ON VIEW view_trial_conversions IS
  'Taxa de conversão de trials por mês';

-- =====================================================
-- 7. MATERIALIZED VIEW: view_subscription_revenue_monthly
-- Receita mensal (para dashboards - atualizar periodicamente)
-- =====================================================

CREATE MATERIALIZED VIEW IF NOT EXISTS view_subscription_revenue_monthly AS
SELECT
  DATE_TRUNC('month', pt.payment_date) AS month,
  COUNT(DISTINCT pt.user_id) AS paying_users,
  COUNT(*) AS total_payments,
  SUM(pt.amount) FILTER (WHERE pt.status IN ('received', 'confirmed')) AS total_revenue,
  SUM(pt.amount) FILTER (WHERE pt.payment_method = 'pix') AS revenue_pix,
  SUM(pt.amount) FILTER (WHERE pt.payment_method = 'boleto') AS revenue_boleto,
  SUM(pt.amount) FILTER (WHERE pt.payment_method = 'credit_card') AS revenue_credit_card,
  AVG(pt.amount) FILTER (WHERE pt.status IN ('received', 'confirmed')) AS avg_payment,
  COUNT(*) FILTER (WHERE pt.status = 'overdue') AS overdue_payments,
  SUM(pt.amount) FILTER (WHERE pt.status = 'overdue') AS overdue_amount
FROM payment_transactions pt
WHERE pt.payment_date IS NOT NULL
GROUP BY DATE_TRUNC('month', pt.payment_date)
ORDER BY month DESC;

-- Índice para a materialized view
CREATE UNIQUE INDEX IF NOT EXISTS idx_revenue_monthly_month
  ON view_subscription_revenue_monthly(month);

COMMENT ON MATERIALIZED VIEW view_subscription_revenue_monthly IS
  'Receita mensal agregada (atualizar com REFRESH MATERIALIZED VIEW)';

-- =====================================================
-- 8. FUNCTION: Refresh materialized view automaticamente
-- =====================================================

CREATE OR REPLACE FUNCTION refresh_subscription_revenue()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY view_subscription_revenue_monthly;
END;
$$;

COMMENT ON FUNCTION refresh_subscription_revenue IS
  'Atualiza a materialized view de receita mensal';

-- =====================================================
-- FIM DAS VIEWS
-- =====================================================

SELECT '🎉 MIGRATION COMPLETADA!' AS status;

SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' AND table_name IN ('subscription_plans', 'subscriptions', 'payment_transactions', 'feature_flags', 'subscription_usage') ORDER BY table_name;
