-- =====================================================
-- MIGRATION: Sistema de Assinaturas - Clube dos 100
-- Data: 2025-12-28
-- Descrição: Cria tabelas, functions, views e policies
--            para sistema de assinaturas com Asaas
-- =====================================================

-- Habilitar extensão UUID se não existir
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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
