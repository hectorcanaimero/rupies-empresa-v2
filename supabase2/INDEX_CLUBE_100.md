# 📚 Índice - Sistema de Assinaturas Clube dos 100

Documentação completa do sistema de assinaturas premium para Rupies Empresa.

---

## 🚀 START HERE

Se você está começando agora, leia nesta ordem:

1. **[RESUMO_FASE_1.md](./RESUMO_FASE_1.md)** ⭐
   Database schema - Visão geral do que foi implementado

2. **[RESUMO_FASE_2.md](./RESUMO_FASE_2.md)** ⭐⭐
   Edge Functions - Integração com Asaas

3. **[EDGE_FUNCTIONS_DEPLOY.md](./EDGE_FUNCTIONS_DEPLOY.md)** ⭐⭐⭐
   **Guia completo para deploy das Edge Functions**

4. **[PLANO_CLUBE_100_ASAAS.md](../PLANO_CLUBE_100_ASAAS.md)**
   Plano completo de implementação (5 fases)

---

## 📖 Documentação por Categoria

### 🎯 Guias de Execução

| Arquivo | Descrição | Quando Usar |
|---------|-----------|-------------|
| **[COMO_EJECUTAR.md](./COMO_EJECUTAR.md)** ⭐⭐⭐ | **GUÍA RÁPIDA** - 3 métodos para ejecutar | **EMPEZAR AQUÍ** |
| [EXECUTAR_MIGRATIONS.md](./EXECUTAR_MIGRATIONS.md) | Guia completo detalhado (português) | Referência completa |
| [README_MIGRATIONS.md](./README_MIGRATIONS.md) | Documentação técnica das migrations | Referência técnica |
| [RESUMO_FASE_1.md](./RESUMO_FASE_1.md) | Resumo da Fase 1 completa | Visão geral |

### 🐛 Troubleshooting & Correções

| Arquivo | Descrição | Quando Usar |
|---------|-----------|-------------|
| [CORRECOES.md](./CORRECOES.md) | Detalhes das correções UUID → TEXT | Se houver erros de tipo |
| **[RESOLVER_TABELA_EXISTENTE.md](./RESOLVER_TABELA_EXISTENTE.md)** ⚠️ | Como lidar com tabela subscriptions pré-existente | **SE TESTE DETECTAR TABELA ANTIGA** |

### 📋 Planejamento

| Arquivo | Descrição | Quando Usar |
|---------|-----------|-------------|
| [PLANO_CLUBE_100_ASAAS.md](../PLANO_CLUBE_100_ASAAS.md) | Plano completo (5 fases, 8-12 dias) | Planejamento geral |

### 🗄️ Migrations SQL

| Arquivo | Descrição | Status |
|---------|-----------|--------|
| [20251228_create_subscription_system.sql](./migrations/20251228_create_subscription_system.sql) | Tabelas, RLS, dados iniciais | ✅ Corrigido |
| [20251228_create_subscription_functions.sql](./migrations/20251228_create_subscription_functions.sql) | Functions PostgreSQL | ✅ Corrigido |
| [20251228_create_subscription_views.sql](./migrations/20251228_create_subscription_views.sql) | Views otimizadas | ✅ OK |

### 🚀 Edge Functions

| Arquivo | Descrição | Status |
|---------|-----------|--------|
| [functions/create-asaas-subscription](./functions/create-asaas-subscription/index.ts) | Criar assinatura no Asaas | ✅ Implementado |
| [functions/handle-asaas-webhook](./functions/handle-asaas-webhook/index.ts) | Processar webhooks do Asaas | ✅ Implementado |
| [functions/cancel-subscription](./functions/cancel-subscription/index.ts) | Cancelar assinatura | ✅ Implementado |
| [functions/get-subscription-status](./functions/get-subscription-status/index.ts) | Consultar status | ✅ Implementado |
| [functions/_shared/asaas-api.ts](./functions/_shared/asaas-api.ts) | Cliente API Asaas | ✅ Implementado |
| [functions/_shared/supabase-client.ts](./functions/_shared/supabase-client.ts) | Utilidades Supabase | ✅ Implementado |
| [functions/README.md](./functions/README.md) | Documentação técnica | ✅ Completo |
| [EDGE_FUNCTIONS_DEPLOY.md](./EDGE_FUNCTIONS_DEPLOY.md) | Guia de deployment | ✅ Completo |

### 🔧 Scripts & Ferramentas

| Arquivo | Descrição | Quando Usar |
|---------|-----------|-------------|
| [test-connection.js](./test-connection.js) | Testa conexão e verifica estado das migrations | Antes e depois de executar |
| [verify-schema.js](./verify-schema.js) | Verifica schema da tabela subscriptions | Se houver tabela existente |
| [check-existing-schema.sql](./check-existing-schema.sql) | Query SQL para inspecionar schema completo | Via SQL Editor manual |
| [ejecutar-migrations.sh](./ejecutar-migrations.sh) | Script bash automatizado (requer psql) | Se tiver acesso psql |

---

## 🗺️ Roadmap do Projeto

### ✅ Fase 1: Database Schema (COMPLETA)

**Status**: ✅ Migrations executadas com sucesso

**Arquivos**:
- ✅ Migrations SQL criadas e corrigidas
- ✅ Documentação completa
- ✅ Guia de execução
- ✅ 5 tabelas criadas
- ✅ 8 functions PostgreSQL
- ✅ 7 views otimizadas

**Verificar**: `cd supabase && node test-connection.js`

---

### ✅ Fase 2: Edge Functions (COMPLETA)

**Status**: ✅ Edge Functions implementadas

**Funções criadas**:

1. ✅ **`create-asaas-subscription`**
   - Criar/buscar cliente no Asaas
   - Criar assinatura (mensal/anual)
   - Gerar pagamento (PIX/Boleto/Cartão)
   - Retornar QR Code PIX e link Boleto

2. ✅ **`handle-asaas-webhook`**
   - Processar webhooks do Asaas
   - Atualizar status de transações
   - Ativar assinatura (PAYMENT_RECEIVED)
   - Marcar como vencida (PAYMENT_OVERDUE)
   - Cancelar por estorno (PAYMENT_REFUNDED)

3. ✅ **`cancel-subscription`**
   - Cancelar no Asaas
   - Cancelar local (imediato ou fim do período)
   - Registrar motivo de cancelamento

4. ✅ **`get-subscription-status`**
   - Consultar status completo
   - Retornar plano, features, uso mensal
   - Histórico de pagamentos

**Utilities criadas**:
- ✅ `_shared/asaas-api.ts`: Cliente completo API Asaas
- ✅ `_shared/supabase-client.ts`: Utilidades Supabase

**Documentação criada**:
- ✅ [EDGE_FUNCTIONS_DEPLOY.md](./EDGE_FUNCTIONS_DEPLOY.md): Guia de deployment
- ✅ [functions/README.md](./functions/README.md): Documentação técnica
- ✅ [RESUMO_FASE_2.md](./RESUMO_FASE_2.md): Resumo da fase

**Próximo passo**: Fazer deploy das Edge Functions → [EDGE_FUNCTIONS_DEPLOY.md](./EDGE_FUNCTIONS_DEPLOY.md)

---

### ⏭️ Fase 3: Flutter UI

**Duração estimada**: 3-4 dias

**Telas a criar**:

1. **Planos e Preços** (`subscription_plans_page.dart`)
   - Exibir 3 planos
   - Comparação de features
   - CTAs para assinar

2. **Checkout** (`checkout_page.dart`)
   - Seleção de método de pagamento
   - PIX: QR Code + Copia e Cola
   - Boleto: Código de barras
   - Cartão: Formulário de dados

3. **Gerenciamento** (`my_subscription_page.dart`)
   - Status atual
   - Próximo pagamento
   - Histórico de transações
   - Botão cancelar

4. **Widgets de Uso**
   - Contador de serviços criados
   - Contador de contatos realizados
   - Barra de progresso dos limites

**Lógica a implementar**:
- Feature flag check antes de mostrar paywall
- Validação de limites antes de ações
- Deep links para checkouts

---

### ⏭️ Fase 4: Testing

**Duração estimada**: 2 dias

**Testes a realizar**:

- [ ] Fluxo completo de assinatura (sandbox)
- [ ] Todos os métodos de pagamento
- [ ] Webhooks Asaas
- [ ] Renovações automáticas
- [ ] Cancelamentos
- [ ] Limites de uso
- [ ] Feature flag

---

### ⏭️ Fase 5: Deploy

**Duração estimada**: 1 dia

**Checklist de deploy**:

- [ ] Migrations executadas em produção
- [ ] Edge Functions deployadas
- [ ] Webhook Asaas configurado
- [ ] Asaas em produção (não sandbox)
- [ ] Testes em produção
- [ ] Monitoramento ativo
- [ ] Feature flag: DESABILITADA (para store)

---

## 🔍 Busca Rápida

### Como fazer...

**...executar as migrations?**
→ [EXECUTAR_MIGRATIONS.md](./EXECUTAR_MIGRATIONS.md)

**...entender as correções aplicadas?**
→ [CORRECOES.md](./CORRECOES.md)

**...ver o plano completo?**
→ [PLANO_CLUBE_100_ASAAS.md](../PLANO_CLUBE_100_ASAAS.md)

**...verificar se migrations rodaram corretamente?**
→ [EXECUTAR_MIGRATIONS.md](./EXECUTAR_MIGRATIONS.md) → Seção "Verificação Pós-Migration"

**...habilitar features premium após aprovação?**
```sql
UPDATE feature_flags SET is_enabled = true WHERE flag_key = 'show_premium_features';
```

**...calcular MRR/ARR?**
```sql
SELECT mrr, arr FROM view_subscription_metrics;
```

**...ver assinaturas ativas?**
```sql
SELECT * FROM view_active_subscriptions;
```

**...fazer rollback das migrations?**
→ [README_MIGRATIONS.md](./README_MIGRATIONS.md) → Seção "Rollback"

---

## 📊 Estrutura de Dados

### Tabelas (5)

```
subscription_plans          → Planos disponíveis (3 planos)
subscriptions              → Assinaturas dos usuários
payment_transactions       → Histórico de pagamentos Asaas
feature_flags              → Controle de features
subscription_usage         → Tracking de uso mensal
```

### Functions (8)

```sql
check_subscription_status(user_id TEXT)
has_premium_feature(user_id TEXT, feature TEXT)
can_create_service(user_id TEXT)
increment_service_usage(user_id TEXT)
process_asaas_webhook(event TEXT, payload JSONB)
cancel_subscription(sub_id UUID, immediate BOOLEAN)
refresh_subscription_revenue()
update_updated_at_column()
```

### Views (7)

```
view_active_subscriptions
view_subscription_metrics
view_user_subscription_summary
view_payment_history
view_churned_subscriptions
view_trial_conversions
view_subscription_revenue_monthly (materialized)
```

---

## 💡 Conceitos Chave

### Feature Flag: `show_premium_features`

**Propósito**: Ocultar features premium para aprovação na loja

**Estados**:
- `false` → App aparece 100% FREE (para Apple/Google)
- `true` → Features premium visíveis (após aprovação)

**Como funciona**:
```dart
// No Flutter
final showPremium = await hasFeatureFlag('show_premium_features');
if (showPremium && !userIsPremium) {
  // Mostrar paywall
} else {
  // Liberar acesso
}
```

### Limites de Uso

| Plano | Serviços/Mês | Contatos/Mês |
|-------|-------------|--------------|
| Grátis | 5 | 10 |
| Premium | Ilimitado (-1) | Ilimitado (-1) |

**Validação**:
```sql
SELECT can_create_service('user-id');
-- Retorna: { can_create: true/false, reason: '...', remaining: N }
```

### Métricas de Negócio

**MRR** (Monthly Recurring Revenue): Receita recorrente mensal
**ARR** (Annual Recurring Revenue): Receita recorrente anual
**Churn**: Taxa de cancelamento
**LTV** (Lifetime Value): Valor total gerado por cliente

---

## 🏗️ Arquitetura do Sistema

```
App Flutter
    ↓
Edge Functions (Supabase)
    ↓
Asaas API (Payment Gateway)
    ↓
PostgreSQL Database (Supabase)
```

**Fluxo de Assinatura**:
1. Usuário seleciona plano no app
2. App chama Edge Function `create-asaas-subscription`
3. Edge Function cria assinatura no Asaas
4. Asaas retorna link de pagamento
5. Usuário paga (PIX/Boleto/Cartão)
6. Asaas envia webhook → `handle-asaas-webhook`
7. Edge Function atualiza banco de dados
8. App consulta status atualizado

---

## 👥 Equipe & Responsabilidades

**Simon** (Supabase Expert):
- ✅ Database schema
- ⏭️ Edge Functions
- ⏭️ Asaas integration
- ⏭️ Webhooks

**Ale** (Flutter Developer):
- ⏭️ UI/UX das telas
- ⏭️ Integração com Edge Functions
- ⏭️ Feature flag logic
- ⏭️ Deep links

---

## 📞 Links Úteis

**Supabase Dashboard**: https://supa.rupies.com.br
**Asaas Docs**: https://docs.asaas.com/
**Asaas Sandbox**: https://sandbox.asaas.com/

---

## 📝 Changelog

### v3.1 (2025-01-02) - CURRENT
- ✅ **Fase 2 Completa**: Edge Functions implementadas
- ✅ 4 Edge Functions criadas (create, webhook, cancel, status)
- ✅ 2 Shared utilities (asaas-api, supabase-client)
- ✅ Documentação completa de deployment
- ✅ Correção: isContractor → "isContractor" (case-sensitive)

### v3.0 (2025-01-02)
- ✅ **Fase 1 Completa**: Migrations executadas com sucesso
- ✅ Correção final: user_id UUID (revertido de TEXT)
- ✅ 5 tabelas, 8 functions, 7 views criadas

### v2.0 (2025-12-28)
- ❌ Tentativa incorreta: UUID → TEXT

### v1.0 (2025-12-28)
- ❌ Versão inicial (erro de tipo UUID)

---

**Última atualização**: 2025-01-02
**Status**: Fase 2 completa, Edge Functions prontas para deploy
**Próximo milestone**: Deploy Edge Functions → Iniciar Fase 3 (Flutter UI)
