# 🗄️ Migrations - Sistema de Assinaturas Clube dos 100

## 📋 Visão Geral

Este diretório contém as migrations SQL para o sistema de assinaturas do Clube dos 100 Rupies, integrado com Asaas.

### Arquivos de Migration

1. **`20251228_create_subscription_system.sql`** - Tabelas, índices, RLS, dados iniciais ✅ CORRIGIDO
2. **`20251228_create_subscription_functions.sql`** - Functions PostgreSQL para lógica de negócio ✅ CORRIGIDO
3. **`20251228_create_subscription_views.sql`** - Views otimizadas e materialized views ✅ OK

### ⚠️ IMPORTANTE: Migrations Corrigidas

As migrations foram **corrigidas** para resolver incompatibilidade de tipos:
- `user_id` alterado de **UUID** para **TEXT** (compatível com `users.id`)
- RLS policies corrigidas com cast `auth.uid()::text`
- Ver detalhes em: **[CORRECOES.md](./CORRECOES.md)**

### 📖 Guia de Execução

**👉 Para executar as migrations, siga o guia completo:**

**[EXECUTAR_MIGRATIONS.md](./EXECUTAR_MIGRATIONS.md)** ⭐

Este guia contém:
- ✅ Ordem correta de execução
- ✅ Passo a passo detalhado
- ✅ Queries de verificação
- ✅ Testes de funções
- ✅ Troubleshooting

## 🚀 Como Executar as Migrations (Resumo)

### Opção 1: Via Supabase Dashboard (Recomendado)

1. Acesse o **Supabase Dashboard**: https://supa.rupies.com.br
2. Vá para **SQL Editor**
3. Execute cada arquivo na ordem:

```
1️⃣ 20251228_create_subscription_system.sql
2️⃣ 20251228_create_subscription_functions.sql
3️⃣ 20251228_create_subscription_views.sql
```

4. Clique em **Run** para cada arquivo

### Opção 2: Via psql (Command Line)

```bash
# Conectar ao banco
psql -h supa.rupies.com.br -U postgres -d postgres

# Executar migrations na ordem
\i supabase/migrations/20251228_create_subscription_system.sql
\i supabase/migrations/20251228_create_subscription_functions.sql
\i supabase/migrations/20251228_create_subscription_views.sql
```

### Opção 3: Script Automatizado

```bash
# Criar script de deploy
cat > supabase/deploy_migrations.sh << 'EOF'
#!/bin/bash

echo "🚀 Deploying migrations to Supabase..."

# Configurações (ajuste conforme necessário)
DB_HOST="supa.rupies.com.br"
DB_USER="postgres"
DB_NAME="postgres"

# Array de migrations na ordem correta
MIGRATIONS=(
  "20251228_create_subscription_system.sql"
  "20251228_create_subscription_functions.sql"
  "20251228_create_subscription_views.sql"
)

# Executar cada migration
for migration in "${MIGRATIONS[@]}"; do
  echo "📄 Executando: $migration"
  psql -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -f "migrations/$migration"

  if [ $? -eq 0 ]; then
    echo "✅ $migration executada com sucesso"
  else
    echo "❌ Erro ao executar $migration"
    exit 1
  fi

  echo ""
done

echo "🎉 Todas as migrations foram executadas com sucesso!"
EOF

chmod +x supabase/deploy_migrations.sh

# Executar
cd supabase
./deploy_migrations.sh
```

## ✅ Verificação Pós-Migration

Após executar as migrations, verificar se tudo foi criado corretamente:

```sql
-- 1. Verificar tabelas criadas
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN (
    'subscription_plans',
    'subscriptions',
    'payment_transactions',
    'feature_flags',
    'subscription_usage'
  );
-- Deve retornar 5 linhas

-- 2. Verificar functions criadas
SELECT routine_name
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_name LIKE '%subscription%'
ORDER BY routine_name;
-- Deve incluir: check_subscription_status, has_premium_feature, etc.

-- 3. Verificar views criadas
SELECT table_name
FROM information_schema.views
WHERE table_schema = 'public'
  AND table_name LIKE '%subscription%'
ORDER BY table_name;
-- Deve incluir várias views

-- 4. Verificar dados iniciais
SELECT COUNT(*) FROM subscription_plans; -- Deve ter pelo menos 3 planos
SELECT COUNT(*) FROM feature_flags WHERE flag_key = 'show_premium_features'; -- Deve ter 1

-- 5. Verificar RLS habilitado
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename IN ('subscriptions', 'payment_transactions')
ORDER BY tablename;
-- rowsecurity deve ser true
```

## 🧪 Testes de Funções

### Testar check_subscription_status

```sql
-- Substituir 'user-uuid' por um UUID real de usuário
SELECT check_subscription_status('user-uuid'::uuid);
```

### Testar has_premium_feature

```sql
-- Verificar acesso a feature (deve retornar true se flag desabilitada)
SELECT has_premium_feature('user-uuid'::uuid, 'unlimited_posts');
```

### Testar can_create_service

```sql
-- Verificar se pode criar serviço
SELECT can_create_service('user-uuid'::uuid);
```

## 📊 Estrutura Criada

### Tabelas

| Tabela | Descrição | Registros Iniciais |
|--------|-----------|-------------------|
| `subscription_plans` | Planos disponíveis | 3 (Grátis, Mensal, Anual) |
| `subscriptions` | Assinaturas dos usuários | 0 |
| `payment_transactions` | Histórico de pagamentos | 0 |
| `feature_flags` | Controle de features | 1 (show_premium_features) |
| `subscription_usage` | Tracking de uso mensal | 0 |

### Functions PostgreSQL

| Function | Descrição |
|----------|-----------|
| `check_subscription_status(uuid)` | Retorna status completo da assinatura |
| `has_premium_feature(uuid, text)` | Verifica acesso a feature |
| `can_create_service(uuid)` | Verifica se pode criar serviço |
| `increment_service_usage(uuid)` | Incrementa contador de uso |
| `process_asaas_webhook(text, jsonb)` | Processa webhooks Asaas |
| `cancel_subscription(uuid, boolean)` | Cancela assinatura |

### Views

| View | Tipo | Descrição |
|------|------|-----------|
| `view_active_subscriptions` | Normal | Assinaturas ativas |
| `view_subscription_metrics` | Normal | Métricas (MRR, ARR) |
| `view_user_subscription_summary` | Normal | Resumo por usuário |
| `view_payment_history` | Normal | Histórico de pagamentos |
| `view_churned_subscriptions` | Normal | Análise de churn |
| `view_trial_conversions` | Normal | Conversão de trials |
| `view_subscription_revenue_monthly` | Materialized | Receita mensal |

## 🔄 Rollback (Se Necessário)

Se precisar reverter as migrations:

```sql
-- ATENÇÃO: Isso apagará TODOS os dados!

-- Remover views
DROP MATERIALIZED VIEW IF EXISTS view_subscription_revenue_monthly CASCADE;
DROP VIEW IF EXISTS view_trial_conversions CASCADE;
DROP VIEW IF EXISTS view_churned_subscriptions CASCADE;
DROP VIEW IF EXISTS view_payment_history CASCADE;
DROP VIEW IF EXISTS view_user_subscription_summary CASCADE;
DROP VIEW IF EXISTS view_subscription_metrics CASCADE;
DROP VIEW IF EXISTS view_active_subscriptions CASCADE;

-- Remover functions
DROP FUNCTION IF EXISTS cancel_subscription CASCADE;
DROP FUNCTION IF EXISTS process_asaas_webhook CASCADE;
DROP FUNCTION IF EXISTS increment_service_usage CASCADE;
DROP FUNCTION IF EXISTS can_create_service CASCADE;
DROP FUNCTION IF EXISTS has_premium_feature CASCADE;
DROP FUNCTION IF EXISTS check_subscription_status CASCADE;
DROP FUNCTION IF EXISTS refresh_subscription_revenue CASCADE;
DROP FUNCTION IF EXISTS update_updated_at_column CASCADE;

-- Remover tabelas (em ordem inversa de dependências)
DROP TABLE IF EXISTS subscription_usage CASCADE;
DROP TABLE IF EXISTS payment_transactions CASCADE;
DROP TABLE IF EXISTS subscriptions CASCADE;
DROP TABLE IF EXISTS subscription_plans CASCADE;
DROP TABLE IF EXISTS feature_flags CASCADE;
```

## 🎯 Próximos Passos

Após executar as migrations com sucesso:

1. ✅ **Verificar que tudo foi criado** (usar queries de verificação acima)
2. ✅ **Configurar flag de feature** (já vem desabilitada por padrão)
3. ⏭️ **Implementar Edge Functions** (Fase 2)
4. ⏭️ **Integrar com Asaas** (Fase 2)
5. ⏭️ **Criar UI Flutter** (Fase 3)

## 📝 Notas Importantes

### Feature Flag Inicial

Por padrão, a feature flag `show_premium_features` está **desabilitada (false)**:

```sql
-- Ver status atual
SELECT * FROM feature_flags WHERE flag_key = 'show_premium_features';

-- Para habilitar depois do lançamento na loja
UPDATE feature_flags
SET is_enabled = true
WHERE flag_key = 'show_premium_features';
```

Quando desabilitada, a function `has_premium_feature()` sempre retorna `true`, fazendo o app funcionar como **100% free** para aprovação nas stores.

### Planos Iniciais

| Plano | Preço Mensal | Preço Anual | Serviços/Mês | Contatos/Mês |
|-------|-------------|-------------|--------------|--------------|
| Grátis | R$ 0 | - | 5 | 10 |
| Clube dos 100 - Mensal | R$ 99,90 | - | Ilimitado | Ilimitado |
| Clube dos 100 - Anual | - | R$ 959,04 | Ilimitado | Ilimitado |

**Ajustar preços se necessário:**

```sql
UPDATE subscription_plans
SET price_monthly = 149.90  -- Novo preço
WHERE name = 'Clube dos 100 - Mensal';
```

## 🔍 Troubleshooting

### Erro: "relation already exists"

Se as tabelas já existem:

```sql
-- Verificar tabelas existentes
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name LIKE '%subscription%';

-- Se necessário, fazer rollback primeiro
```

### Erro: "permission denied"

Verificar permissões do usuário:

```sql
-- Garantir que usuário tem permissões
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO postgres;
```

### Views não aparecem

```sql
-- Recriar views
\i supabase/migrations/20251228_create_subscription_views.sql
```

---

**Criado por**: Simon (Especialista Supabase) & Ale (Flutter Developer)
**Data**: 2025-12-28
**Versão**: 1.0.0
