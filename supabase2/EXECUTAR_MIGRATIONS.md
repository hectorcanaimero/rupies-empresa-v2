# 🚀 Guia de Execução - Migrations Clube dos 100

## ✅ Status das Migrations

Todas as migrations foram **corrigidas** e estão prontas para execução.

### Correções Aplicadas
- ✅ Tipo `user_id` alterado de UUID para TEXT
- ✅ RLS policies corrigidas com cast `auth.uid()::text`
- ✅ Functions corrigidas para aceitar `TEXT` ao invés de `UUID`
- ✅ Extensão `btree_gist` adicionada

📄 Ver detalhes em: [CORRECOES.md](./CORRECOES.md)

---

## 📋 Ordem de Execução

Execute as migrations **nesta ordem exata**:

```
1️⃣ 20251228_create_subscription_system.sql
2️⃣ 20251228_create_subscription_functions.sql
3️⃣ 20251228_create_subscription_views.sql
```

---

## 🎯 Passo a Passo

### Opção 1: Via Supabase Dashboard (Recomendado)

1. **Acesse o Supabase Dashboard**
   ```
   https://supa.rupies.com.br
   ```

2. **Vá para SQL Editor**
   - Menu lateral → SQL Editor
   - Clique em "New Query"

3. **Execute Migration 1**
   - Copie todo o conteúdo de `20251228_create_subscription_system.sql`
   - Cole no editor
   - Clique em **Run** (ou Ctrl/Cmd + Enter)
   - ✅ Aguarde confirmação de sucesso

4. **Execute Migration 2**
   - Copie todo o conteúdo de `20251228_create_subscription_functions.sql`
   - Cole no editor
   - Clique em **Run**
   - ✅ Aguarde confirmação de sucesso

5. **Execute Migration 3**
   - Copie todo o conteúdo de `20251228_create_subscription_views.sql`
   - Cole no editor
   - Clique em **Run**
   - ✅ Aguarde confirmação de sucesso

### Opção 2: Via psql (Command Line)

```bash
# Conectar ao banco
psql -h supa.rupies.com.br -U postgres -d postgres

# Executar migrations na ordem
\i supabase/migrations/20251228_create_subscription_system.sql
\i supabase/migrations/20251228_create_subscription_functions.sql
\i supabase/migrations/20251228_create_subscription_views.sql

# Sair
\q
```

---

## ✅ Verificação Pós-Migration

Após executar todas as migrations, execute estas queries para confirmar:

### 1. Verificar Tabelas Criadas

```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN (
    'subscription_plans',
    'subscriptions',
    'payment_transactions',
    'feature_flags',
    'subscription_usage'
  )
ORDER BY table_name;
```

**Resultado esperado**: 5 tabelas

### 2. Verificar Tipo da Coluna user_id

```sql
SELECT
  table_name,
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name IN ('subscriptions', 'payment_transactions', 'subscription_usage')
  AND column_name = 'user_id'
ORDER BY table_name;
```

**Resultado esperado**: Todas devem mostrar `data_type = text`

### 3. Verificar Planos Inseridos

```sql
SELECT
  name,
  price_monthly,
  price_yearly,
  max_services_per_month,
  max_contractors_contacted
FROM subscription_plans
ORDER BY price_monthly NULLS FIRST;
```

**Resultado esperado**: 3 planos
- Grátis: R$ 0
- Clube dos 100 - Mensal: R$ 99,90
- Clube dos 100 - Anual: R$ 959,04/ano

### 4. Verificar Feature Flag

```sql
SELECT * FROM feature_flags WHERE flag_key = 'show_premium_features';
```

**Resultado esperado**:
- `is_enabled = false` (features premium ocultas para aprovação na loja)

### 5. Verificar Functions Criadas

```sql
SELECT
  routine_name,
  routine_type
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_name LIKE '%subscription%'
ORDER BY routine_name;
```

**Resultado esperado**: Deve incluir:
- `cancel_subscription`
- `can_create_service`
- `check_subscription_status`
- `has_premium_feature`
- `increment_service_usage`
- `process_asaas_webhook`
- `refresh_subscription_revenue`

### 6. Verificar Views Criadas

```sql
SELECT
  table_name,
  table_type
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name LIKE 'view_%subscription%'
ORDER BY table_name;
```

**Resultado esperado**: 7 views (6 normais + 1 materializada)

### 7. Verificar RLS Habilitado

```sql
SELECT
  tablename,
  rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN ('subscriptions', 'payment_transactions', 'subscription_usage')
ORDER BY tablename;
```

**Resultado esperado**: `rowsecurity = true` para todas

---

## 🧪 Testes de Funções

### Testar check_subscription_status

```sql
-- Substituir 'USER_ID_AQUI' por um user_id real (TEXT) da tabela users
SELECT check_subscription_status('USER_ID_AQUI');
```

**Resultado esperado**: JSON com `has_active_subscription = false` (se usuário não tem assinatura)

### Testar has_premium_feature

```sql
-- Quando flag desabilitada, sempre retorna true (modo free)
SELECT has_premium_feature('USER_ID_AQUI', 'unlimited_posts');
```

**Resultado esperado**: `true` (porque flag está desabilitada)

### Testar can_create_service

```sql
SELECT can_create_service('USER_ID_AQUI');
```

**Resultado esperado**: JSON com `can_create = true` (modo free permite tudo)

---

## 🎯 Próximos Passos

Após verificar que tudo foi criado corretamente:

### ✅ Fase 1: Database (COMPLETA)
- [x] Migrations criadas e corrigidas
- [x] Documentação gerada

### ⏭️ Fase 2: Edge Functions (PRÓXIMO)

Implementar Edge Functions para integração com Asaas:

1. **create-asaas-subscription**
   - Criar assinatura no Asaas
   - Criar registro em `subscriptions`
   - Retornar link de pagamento

2. **handle-asaas-webhook**
   - Receber webhooks do Asaas
   - Atualizar status de assinatura
   - Processar pagamentos
   - Gerenciar renovações/cancelamentos

3. **cancel-subscription**
   - Cancelar no Asaas
   - Atualizar status local

4. **get-subscription-status**
   - Consultar status atual do usuário

### ⏭️ Fase 3: Flutter UI

Implementar telas no app:
- Planos e preços
- Checkout (PIX, Boleto, Cartão)
- Gerenciamento de assinatura
- Status e uso

### ⏭️ Fase 4: Feature Flag

Habilitar premium features após aprovação na loja:

```sql
UPDATE feature_flags
SET is_enabled = true
WHERE flag_key = 'show_premium_features';
```

---

## 🔄 Rollback (Se Necessário)

Se precisar desfazer as migrations:

```sql
-- ATENÇÃO: Isso apagará TODOS os dados!

-- 1. Remover views
DROP MATERIALIZED VIEW IF EXISTS view_subscription_revenue_monthly CASCADE;
DROP VIEW IF EXISTS view_trial_conversions CASCADE;
DROP VIEW IF EXISTS view_churned_subscriptions CASCADE;
DROP VIEW IF EXISTS view_payment_history CASCADE;
DROP VIEW IF EXISTS view_user_subscription_summary CASCADE;
DROP VIEW IF EXISTS view_subscription_metrics CASCADE;
DROP VIEW IF EXISTS view_active_subscriptions CASCADE;

-- 2. Remover functions
DROP FUNCTION IF EXISTS cancel_subscription CASCADE;
DROP FUNCTION IF EXISTS process_asaas_webhook CASCADE;
DROP FUNCTION IF EXISTS increment_service_usage CASCADE;
DROP FUNCTION IF EXISTS can_create_service CASCADE;
DROP FUNCTION IF EXISTS has_premium_feature CASCADE;
DROP FUNCTION IF EXISTS check_subscription_status CASCADE;
DROP FUNCTION IF EXISTS refresh_subscription_revenue CASCADE;
DROP FUNCTION IF EXISTS update_updated_at_column CASCADE;

-- 3. Remover tabelas (ordem inversa)
DROP TABLE IF EXISTS subscription_usage CASCADE;
DROP TABLE IF EXISTS payment_transactions CASCADE;
DROP TABLE IF EXISTS subscriptions CASCADE;
DROP TABLE IF EXISTS subscription_plans CASCADE;
DROP TABLE IF EXISTS feature_flags CASCADE;
```

---

## 📞 Suporte

Em caso de erros:

1. Verifique os logs no SQL Editor do Supabase
2. Confirme que está executando na ordem correta
3. Verifique se há tabelas/functions com nomes conflitantes
4. Consulte [CORRECOES.md](./CORRECOES.md) para detalhes das correções aplicadas
5. Consulte [README_MIGRATIONS.md](./README_MIGRATIONS.md) para documentação completa

---

**Criado por**: Simon (Supabase Expert) & Ale (Flutter Developer)
**Data**: 2025-12-28
**Status**: ✅ Pronto para executar
**Versão**: 2.0 (corrigido)
