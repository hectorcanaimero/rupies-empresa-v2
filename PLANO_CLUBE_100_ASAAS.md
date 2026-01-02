# 📋 Plano de Implementação - Clube dos 100 Rupies + Asaas

## 🎯 Visão Geral do Projeto

Implementar um sistema de **assinaturas premium** para empresas no app Rupies Empresas, usando **Asaas** como gateway de pagamento, com capacidade de ocultar features pagas antes do lançamento na loja (flag de controle).

### Conceito: Clube dos 100 Rupies
Programa exclusivo que oferece benefícios premium para empresas que assinam.

---

## 🏗️ Arquitetura Proposta (Database-First - Simon)

```
┌─────────────────┐
│  Flutter App    │
│  (Empresas)     │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│         Supabase Self-Hosted            │
│  ┌────────────────────────────────────┐ │
│  │  Tables:                           │ │
│  │  - subscriptions                   │ │
│  │  - subscription_plans              │ │
│  │  - payment_transactions            │ │
│  │  - feature_flags                   │ │
│  │                                    │ │
│  │  Functions PostgreSQL:             │ │
│  │  - check_subscription_status()     │ │
│  │  - has_premium_feature()           │ │
│  │  - process_payment_webhook()       │ │
│  │                                    │ │
│  │  Views:                            │ │
│  │  - view_active_subscriptions       │ │
│  │  - view_subscription_metrics       │ │
│  └────────────────────────────────────┘ │
│                                         │
│  ┌────────────────────────────────────┐ │
│  │  Edge Functions (Deno):            │ │
│  │  - create-asaas-subscription       │ │
│  │  - handle-asaas-webhook            │ │
│  │  - cancel-subscription             │ │
│  └────────────────────────────────────┘ │
└───────────────┬─────────────────────────┘
                │
                ▼
        ┌───────────────┐
        │  Asaas API    │
        │  (Pagamentos) │
        └───────────────┘
```

---

## 📊 Schema do Banco de Dados

### 1. Tabela: `subscription_plans`
Planos de assinatura disponíveis

```sql
CREATE TABLE subscription_plans (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,                      -- Ex: "Clube dos 100 - Mensal"
  description TEXT,
  price_monthly DECIMAL(10,2),             -- Preço mensal em BRL
  price_yearly DECIMAL(10,2),              -- Preço anual em BRL (com desconto)
  asaas_plan_id TEXT,                      -- ID do plano no Asaas
  features JSONB NOT NULL DEFAULT '[]',    -- Lista de features: ["unlimited_posts", "priority_support"]
  max_services_per_month INT,              -- Limite de serviços/mês
  max_contractors_contacted INT,           -- Limite de contatos com contractors
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_subscription_plans_active ON subscription_plans(is_active);

-- Comentário
COMMENT ON TABLE subscription_plans IS
'Planos de assinatura disponíveis no app';
```

### 2. Tabela: `subscriptions`
Assinaturas ativas/históricas dos usuários

```sql
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  plan_id UUID NOT NULL REFERENCES subscription_plans(id),
  asaas_subscription_id TEXT UNIQUE,       -- ID da assinatura no Asaas
  asaas_customer_id TEXT,                  -- ID do cliente no Asaas
  status TEXT NOT NULL DEFAULT 'pending',  -- pending, active, past_due, canceled, expired
  billing_cycle TEXT NOT NULL,             -- monthly, yearly
  current_period_start TIMESTAMPTZ,
  current_period_end TIMESTAMPTZ,
  cancel_at_period_end BOOLEAN DEFAULT false,
  canceled_at TIMESTAMPTZ,
  trial_end TIMESTAMPTZ,                   -- Data fim do trial (se houver)
  metadata JSONB DEFAULT '{}',             -- Dados extras
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_subscriptions_user ON subscriptions(user_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_asaas ON subscriptions(asaas_subscription_id);
CREATE UNIQUE INDEX idx_subscriptions_active_user
  ON subscriptions(user_id)
  WHERE status = 'active';

-- RLS Policies
ALTER TABLE subscriptions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own subscriptions"
  ON subscriptions FOR SELECT
  USING (auth.uid() = user_id);

-- Comentário
COMMENT ON TABLE subscriptions IS
'Assinaturas dos usuários empresas';
```

### 3. Tabela: `payment_transactions`
Histórico de transações de pagamento

```sql
CREATE TABLE payment_transactions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  subscription_id UUID REFERENCES subscriptions(id),
  user_id UUID NOT NULL REFERENCES users(id),
  asaas_payment_id TEXT UNIQUE,            -- ID do pagamento no Asaas
  amount DECIMAL(10,2) NOT NULL,
  currency TEXT DEFAULT 'BRL',
  status TEXT NOT NULL,                     -- pending, confirmed, received, overdue
  payment_method TEXT,                      -- credit_card, boleto, pix
  due_date DATE,
  payment_date TIMESTAMPTZ,
  invoice_url TEXT,                         -- URL do boleto/fatura
  pix_qr_code TEXT,                        -- QR Code PIX
  pix_copy_paste TEXT,                     -- Código PIX copia e cola
  error_message TEXT,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices
CREATE INDEX idx_payment_transactions_subscription ON payment_transactions(subscription_id);
CREATE INDEX idx_payment_transactions_user ON payment_transactions(user_id);
CREATE INDEX idx_payment_transactions_status ON payment_transactions(status);
CREATE INDEX idx_payment_transactions_asaas ON payment_transactions(asaas_payment_id);

-- RLS
ALTER TABLE payment_transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own transactions"
  ON payment_transactions FOR SELECT
  USING (auth.uid() = user_id);

-- Comentário
COMMENT ON TABLE payment_transactions IS
'Histórico de transações de pagamento via Asaas';
```

### 4. Tabela: `feature_flags`
Controle de features (incluindo flag para ocultar paywall)

```sql
CREATE TABLE feature_flags (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  flag_key TEXT NOT NULL UNIQUE,           -- Ex: "show_premium_features"
  description TEXT,
  is_enabled BOOLEAN DEFAULT false,
  target_audience TEXT DEFAULT 'all',      -- all, premium, free
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índice
CREATE INDEX idx_feature_flags_key ON feature_flags(flag_key);

-- Inserir flag principal
INSERT INTO feature_flags (flag_key, description, is_enabled, metadata)
VALUES (
  'show_premium_features',
  'Controla se features premium são visíveis no app (para lançamento na loja)',
  false,  -- Desabilitado por padrão
  '{"controlled_features": ["subscription_screen", "premium_badge", "upgrade_prompts"]}'::jsonb
);

-- Comentário
COMMENT ON TABLE feature_flags IS
'Feature flags para controle de funcionalidades no app';
```

---

## 🔧 Functions PostgreSQL (Simon)

### 1. Verificar Status de Assinatura

```sql
CREATE OR REPLACE FUNCTION check_subscription_status(p_user_id UUID)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_subscription RECORD;
  v_plan RECORD;
BEGIN
  -- Buscar assinatura ativa
  SELECT s.*, p.name as plan_name, p.features
  INTO v_subscription
  FROM subscriptions s
  INNER JOIN subscription_plans p ON p.id = s.plan_id
  WHERE s.user_id = p_user_id
    AND s.status = 'active'
    AND s.current_period_end > NOW()
  ORDER BY s.created_at DESC
  LIMIT 1;

  IF NOT FOUND THEN
    RETURN json_build_object(
      'has_active_subscription', false,
      'is_premium', false,
      'plan', null,
      'features', '[]'::json
    );
  END IF;

  RETURN json_build_object(
    'has_active_subscription', true,
    'is_premium', true,
    'plan', json_build_object(
      'id', v_subscription.plan_id,
      'name', v_subscription.plan_name,
      'billing_cycle', v_subscription.billing_cycle,
      'current_period_end', v_subscription.current_period_end
    ),
    'features', v_subscription.features
  );
END;
$$;

COMMENT ON FUNCTION check_subscription_status IS
'Verifica se usuário tem assinatura ativa e retorna detalhes';
```

### 2. Verificar Acesso a Feature

```sql
CREATE OR REPLACE FUNCTION has_premium_feature(
  p_user_id UUID,
  p_feature_key TEXT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_has_feature BOOLEAN;
BEGIN
  -- Verificar se feature flag global está habilitada
  -- Se show_premium_features = false, sempre retorna true (modo free)
  IF NOT EXISTS (
    SELECT 1 FROM feature_flags
    WHERE flag_key = 'show_premium_features'
      AND is_enabled = true
  ) THEN
    RETURN true;  -- Modo "free" para loja
  END IF;

  -- Verificar se usuário tem assinatura com a feature
  SELECT EXISTS(
    SELECT 1
    FROM subscriptions s
    INNER JOIN subscription_plans p ON p.id = s.plan_id
    WHERE s.user_id = p_user_id
      AND s.status = 'active'
      AND s.current_period_end > NOW()
      AND p.features ? p_feature_key  -- Operador JSONB contains
  ) INTO v_has_feature;

  RETURN v_has_feature;
END;
$$;

COMMENT ON FUNCTION has_premium_feature IS
'Verifica se usuário tem acesso a uma feature premium específica';
```

### 3. Processar Webhook Asaas

```sql
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
BEGIN
  v_asaas_payment_id := p_payment_data->>'id';
  v_status := p_payment_data->>'status';

  -- Atualizar transação
  UPDATE payment_transactions
  SET status = v_status,
      payment_date = CASE
        WHEN v_status IN ('RECEIVED', 'CONFIRMED') THEN NOW()
        ELSE payment_date
      END,
      updated_at = NOW()
  WHERE asaas_payment_id = v_asaas_payment_id
  RETURNING subscription_id INTO v_subscription_id;

  -- Se pagamento confirmado, ativar assinatura
  IF v_status IN ('RECEIVED', 'CONFIRMED') AND v_subscription_id IS NOT NULL THEN
    UPDATE subscriptions
    SET status = 'active',
        updated_at = NOW()
    WHERE id = v_subscription_id;
  END IF;

  -- Se pagamento vencido, marcar como past_due
  IF v_status = 'OVERDUE' AND v_subscription_id IS NOT NULL THEN
    UPDATE subscriptions
    SET status = 'past_due',
        updated_at = NOW()
    WHERE id = v_subscription_id;
  END IF;

  RETURN json_build_object(
    'success', true,
    'processed_at', NOW()
  );
END;
$$;

COMMENT ON FUNCTION process_asaas_webhook IS
'Processa webhooks do Asaas e atualiza status de pagamentos/assinaturas';
```

---

## 🚀 Edge Functions (Supabase + Deno)

### 1. Criar Assinatura Asaas
**Arquivo**: `supabase/functions/create-asaas-subscription/index.ts`

```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const ASAAS_API_URL = 'https://www.asaas.com/api/v3';
const ASAAS_API_KEY = Deno.env.get('ASAAS_API_KEY') ?? '';

serve(async (req) => {
  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    const { planId, billingCycle, paymentMethod } = await req.json();

    // Obter usuário autenticado
    const authHeader = req.headers.get('Authorization')!;
    const token = authHeader.replace('Bearer ', '');
    const { data: { user }, error: authError } = await supabase.auth.getUser(token);

    if (authError || !user) {
      throw new Error('Não autenticado');
    }

    // Buscar dados do usuário
    const { data: userData } = await supabase
      .from('users')
      .select('*')
      .eq('id', user.id)
      .single();

    // Criar/Obter cliente no Asaas
    const asaasCustomer = await createAsaasCustomer(userData);

    // Buscar plano
    const { data: plan } = await supabase
      .from('subscription_plans')
      .select('*')
      .eq('id', planId)
      .single();

    // Criar assinatura no Asaas
    const asaasSubscription = await createAsaasSubscriptionAPI({
      customer: asaasCustomer.id,
      billingType: paymentMethod,  // BOLETO, CREDIT_CARD, PIX
      value: billingCycle === 'yearly' ? plan.price_yearly : plan.price_monthly,
      nextDueDate: getNextDueDate(),
      cycle: billingCycle === 'yearly' ? 'YEARLY' : 'MONTHLY',
    });

    // Salvar no banco
    const { data: subscription } = await supabase
      .from('subscriptions')
      .insert({
        user_id: user.id,
        plan_id: planId,
        asaas_subscription_id: asaasSubscription.id,
        asaas_customer_id: asaasCustomer.id,
        status: 'pending',
        billing_cycle: billingCycle,
        current_period_start: new Date(),
        current_period_end: getNextPeriodEnd(billingCycle),
      })
      .select()
      .single();

    // Criar primeira cobrança
    const { data: transaction } = await supabase
      .from('payment_transactions')
      .insert({
        subscription_id: subscription.id,
        user_id: user.id,
        asaas_payment_id: asaasSubscription.id,
        amount: asaasSubscription.value,
        status: 'pending',
        payment_method: paymentMethod,
        invoice_url: asaasSubscription.invoiceUrl,
        pix_qr_code: asaasSubscription.pixQrCodeUrl,
        pix_copy_paste: asaasSubscription.pixCopyPaste,
      })
      .select()
      .single();

    return new Response(JSON.stringify({
      success: true,
      subscription,
      payment: {
        invoiceUrl: asaasSubscription.invoiceUrl,
        pixQrCode: asaasSubscription.pixQrCodeUrl,
        pixCopyPaste: asaasSubscription.pixCopyPaste,
      },
    }), {
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }
});

// Helpers
async function createAsaasCustomer(userData: any) {
  const response = await fetch(`${ASAAS_API_URL}/customers`, {
    method: 'POST',
    headers: {
      'access_token': ASAAS_API_KEY,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      name: userData.display_name || userData.name_contractor,
      email: userData.email,
      cpfCnpj: userData.cpfcnpj,
      phone: userData.phone,
    }),
  });
  return await response.json();
}

async function createAsaasSubscriptionAPI(data: any) {
  const response = await fetch(`${ASAAS_API_URL}/subscriptions`, {
    method: 'POST',
    headers: {
      'access_token': ASAAS_API_KEY,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(data),
  });
  return await response.json();
}

function getNextDueDate(): string {
  const date = new Date();
  date.setDate(date.getDate() + 7); // 7 dias para primeiro pagamento
  return date.toISOString().split('T')[0];
}

function getNextPeriodEnd(cycle: string): Date {
  const date = new Date();
  if (cycle === 'yearly') {
    date.setFullYear(date.getFullYear() + 1);
  } else {
    date.setMonth(date.getMonth() + 1);
  }
  return date;
}
```

### 2. Handle Webhook Asaas
**Arquivo**: `supabase/functions/handle-asaas-webhook/index.ts`

```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

serve(async (req) => {
  try {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    const webhookData = await req.json();
    const eventType = webhookData.event;
    const paymentData = webhookData.payment;

    console.log('Webhook recebido:', eventType, paymentData);

    // Processar via PostgreSQL function
    const { data, error } = await supabase.rpc('process_asaas_webhook', {
      p_event_type: eventType,
      p_payment_data: paymentData,
    });

    if (error) throw error;

    return new Response(JSON.stringify({ success: true, data }), {
      headers: { 'Content-Type': 'application/json' },
    });
  } catch (error) {
    console.error('Erro no webhook:', error);
    return new Response(JSON.stringify({ error: error.message }), {
      status: 400,
      headers: { 'Content-Type': 'application/json' },
    });
  }
});
```

---

## 🎨 UI/UX no Flutter (Ale)

### 1. Tela de Planos

```dart
// lib/pages/subscription_plans_page/subscription_plans_page.dart

class SubscriptionPlansPage extends StatefulWidget {
  @override
  _SubscriptionPlansPageState createState() => _SubscriptionPlansPageState();
}

class _SubscriptionPlansPageState extends State<SubscriptionPlansPage> {
  bool _showPremiumFeatures = false;

  @override
  void initState() {
    super.initState();
    _checkFeatureFlag();
  }

  Future<void> _checkFeatureFlag() async {
    // Verificar feature flag
    final response = await SupaFlow.client
        .from('feature_flags')
        .select('is_enabled')
        .eq('flag_key', 'show_premium_features')
        .single();

    setState(() {
      _showPremiumFeatures = response['is_enabled'] ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Se feature flag desabilitada, não mostrar esta tela
    if (!_showPremiumFeatures) {
      return Scaffold(
        body: Center(
          child: Text('Feature em desenvolvimento'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Clube dos 100 Rupies')),
      body: FutureBuilder(
        future: _loadPlans(),
        builder: (context, snapshot) {
          // Renderizar planos...
        },
      ),
    );
  }

  Future<List<SubscriptionPlanRow>> _loadPlans() async {
    final response = await SupaFlow.client
        .from('subscription_plans')
        .select()
        .eq('is_active', true);
    return response.map((e) => SubscriptionPlanRow(e)).toList();
  }
}
```

### 2. Custom Action: Verificar Assinatura

```dart
// lib/custom_code/actions/check_subscription.dart

Future<bool> checkSubscription(String featureKey) async {
  final userId = currentUserUid;
  if (userId == null) return false;

  final response = await SupaFlow.client
      .rpc('has_premium_feature', params: {
        'p_user_id': userId,
        'p_feature_key': featureKey,
      });

  return response ?? false;
}
```

---

## 📋 Checklist de Implementação

### Fase 1: Setup Inicial (1-2 dias)
- [ ] Criar tabelas no Supabase (subscriptions, plans, transactions, feature_flags)
- [ ] Criar functions PostgreSQL (check_subscription_status, has_premium_feature, process_webhook)
- [ ] Inserir planos iniciais
- [ ] Configurar RLS policies
- [ ] Criar índices de performance

### Fase 2: Integração Asaas (2-3 dias)
- [ ] Criar conta sandbox Asaas
- [ ] Implementar Edge Function: create-asaas-subscription
- [ ] Implementar Edge Function: handle-asaas-webhook
- [ ] Configurar webhook Asaas → Supabase
- [ ] Testar fluxo completo de pagamento

### Fase 3: UI Flutter (2-3 dias)
- [ ] Tela de planos de assinatura
- [ ] Tela de pagamento (PIX/Boleto/Cartão)
- [ ] Tela de gerenciamento de assinatura
- [ ] Badge "Premium" para usuários assinantes
- [ ] Bloqueios de features para free users

### Fase 4: Feature Flags (1 dia)
- [ ] Implementar sistema de feature flags
- [ ] Criar toggle admin para show_premium_features
- [ ] Testar modo "free" para loja
- [ ] Documentar processo de ativação pós-lançamento

### Fase 5: Testes & Deploy (2 dias)
- [ ] Testes de pagamento em sandbox
- [ ] Testes de webhooks
- [ ] Testes de renovação automática
- [ ] Deploy em produção

---

## 💰 Estimativa de Custos

### Asaas
- **Taxa**: 1,99% + R$ 0,49 por transação (PIX/Boleto)
- **Cartão**: 3,99% + R$ 0,49 por transação
- **Sem mensalidade** no plano inicial

### Supabase (Self-hosted)
- **Edge Functions**: R$ 0,00 (self-hosted)
- **Database**: Incluído no plano atual

---

## 🎯 Próximos Passos

**Para começar a implementação:**

1. ✅ **Aprovação do Plano** - Você valida este documento
2. 📊 **Definir Preços** - Valores mensais/anuais do Clube dos 100
3. 🏗️ **Setup Inicial** - Simon cria schema do banco
4. 🔌 **Integração Asaas** - Edge Functions
5. 🎨 **UI Flutter** - Ale implementa telas
6. 🧪 **Testes** - Validação completa
7. 🚀 **Deploy** - Lançamento gradual

---

**Desenvolvedores responsáveis:**
- **Simon**: Database schema, Functions PostgreSQL, Edge Functions
- **Ale**: UI Flutter, Custom Actions, Integração com Supabase

**Tempo estimado**: 8-12 dias de desenvolvimento

**Status**: ⏳ Aguardando aprovação
