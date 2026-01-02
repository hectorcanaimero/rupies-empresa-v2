# ⚠️ Resolver Tabela `subscriptions` Existente

## 🔍 Situação Detectada

O teste de conexão revelou que a tabela `subscriptions` **já existe** no banco de dados, mas as outras tabelas do sistema de assinaturas ainda não foram criadas.

```
✅ subscriptions          (EXISTE - provavelmente versão antiga)
❌ subscription_plans      (NÃO EXISTE)
❌ payment_transactions    (NÃO EXISTE)
❌ feature_flags          (NÃO EXISTE)
❌ subscription_usage     (NÃO EXISTE)
```

Isso indica que houve uma tentativa anterior de criar o sistema, mas não foi completada.

---

## 📋 Passo a Passo para Resolver

### Etapa 1: Verificar Schema Atual

Execute o script de verificação no SQL Editor do Supabase:

**Arquivo**: [check-existing-schema.sql](./check-existing-schema.sql)

1. Acesse: https://supa.rupies.com.br → SQL Editor
2. Copie todo o conteúdo de `check-existing-schema.sql`
3. Execute
4. Analise os resultados

### Etapa 2: Decidir a Estratégia

Baseado nos resultados, escolha uma das opções:

#### Opção A: Tabela Vazia ou de Teste → RECRIAR ✅ RECOMENDADO

**Quando usar**: Se a tabela não tem dados ou tem apenas dados de teste

```sql
-- 1. Desabilitar RLS temporariamente (se necessário)
ALTER TABLE IF EXISTS subscriptions DISABLE ROW LEVEL SECURITY;

-- 2. Dropar tabela existente
DROP TABLE IF EXISTS subscriptions CASCADE;

-- 3. Agora execute as migrations normalmente
-- Siga: EXECUTAR_MIGRATIONS.md
```

#### Opção B: Tabela com Dados de Produção → MIGRAR ⚠️ CUIDADO

**Quando usar**: Se a tabela tem dados reais de usuários

```sql
-- 1. Fazer backup dos dados
CREATE TABLE subscriptions_backup AS SELECT * FROM subscriptions;

-- 2. Verificar tipo de user_id
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'subscriptions' AND column_name = 'user_id';

-- 3a. Se user_id for UUID → Converter para TEXT
ALTER TABLE subscriptions
ALTER COLUMN user_id TYPE TEXT USING user_id::text;

-- 3b. Se user_id já for TEXT → OK, prosseguir

-- 4. Verificar se faltam colunas e adicionar se necessário
-- (Compare com o schema em 20251228_create_subscription_system.sql)

-- 5. Executar as outras migrations (pular a criação de subscriptions)
```

#### Opção C: Ambiente de Desenvolvimento → LIMPAR TUDO 🧹

**Quando usar**: Se for ambiente de desenvolvimento e pode apagar tudo

```sql
-- ATENÇÃO: Isso apaga TODOS os dados de assinaturas!

DROP TABLE IF EXISTS subscription_usage CASCADE;
DROP TABLE IF EXISTS payment_transactions CASCADE;
DROP TABLE IF EXISTS subscriptions CASCADE;
DROP TABLE IF EXISTS subscription_plans CASCADE;
DROP TABLE IF EXISTS feature_flags CASCADE;

-- Agora execute as migrations normalmente
-- Siga: EXECUTAR_MIGRATIONS.md
```

---

## 🚀 Execução Recomendada (Opção A)

### Passo 1: Verificar se há dados

```sql
SELECT COUNT(*) FROM subscriptions;
```

**Se retornar 0**: Pode dropar sem medo ✅

### Passo 2: Dropar tabela antiga

```sql
-- Dropar com CASCADE para remover dependências
DROP TABLE IF EXISTS subscriptions CASCADE;
```

### Passo 3: Executar migrations

Agora siga normalmente o guia:

👉 **[EXECUTAR_MIGRATIONS.md](./EXECUTAR_MIGRATIONS.md)**

Execute na ordem:
1. `20251228_create_subscription_system.sql`
2. `20251228_create_subscription_functions.sql`
3. `20251228_create_subscription_views.sql`

### Passo 4: Verificar

```sql
-- Deve retornar 5 tabelas
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
```

---

## 🧪 Testar Novamente

Após resolver e executar as migrations, rode novamente o teste:

```bash
cd supabase
node test-connection.js
```

**Resultado esperado**:
```
📊 Resultado:
   ✅ subscription_plans
   ✅ subscriptions
   ✅ payment_transactions
   ✅ feature_flags
   ✅ subscription_usage

🎉 Migrations já foram executadas!
```

---

## 📝 Checklist de Resolução

- [ ] Executar `check-existing-schema.sql`
- [ ] Verificar se há dados na tabela
- [ ] Escolher estratégia (A, B ou C)
- [ ] Fazer backup se necessário
- [ ] Dropar tabela antiga (se aplicável)
- [ ] Executar migrations
- [ ] Verificar criação das 5 tabelas
- [ ] Testar com `node test-connection.js`
- [ ] Confirmar que tudo está ✅

---

## 🆘 Problemas Comuns

### Erro: "cannot drop table because other objects depend on it"

```sql
-- Usar CASCADE para dropar dependências também
DROP TABLE subscriptions CASCADE;
```

### Erro: "permission denied"

Você precisa de permissões de superuser. Use:
- SQL Editor com usuário admin do Supabase
- Ou conecte via `psql` com usuário postgres

### Tabela tem dados importantes

1. Fazer backup completo:
```sql
CREATE TABLE subscriptions_backup_20250102 AS SELECT * FROM subscriptions;
```

2. Exportar para CSV via Dashboard
3. Depois recriar e reimportar após ajustes

---

## 📞 Próximos Passos

Após resolver a tabela existente e executar as migrations:

1. ✅ Confirmar que todas as 5 tabelas existem
2. ✅ Verificar que user_id é do tipo TEXT
3. ✅ Testar functions: `SELECT check_subscription_status('user-id')`
4. ✅ Verificar feature flag: `SELECT * FROM feature_flags`
5. 🚀 Iniciar **Fase 2: Edge Functions**

---

**Criado por**: Ale & Simon
**Data**: 2025-01-02
**Contexto**: Teste de conexão detectou tabela subscriptions pré-existente
