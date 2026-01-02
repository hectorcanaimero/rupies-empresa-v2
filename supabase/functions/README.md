# Edge Functions - Clube dos 100 Asaas Integration

Edge Functions para integração com o gateway de pagamento Asaas.

---

## 📚 Functions Disponíveis

### 1. `create-asaas-subscription`

Cria uma nova assinatura no Asaas e registra no banco de dados local.

**Endpoint**: `POST /functions/v1/create-asaas-subscription`

**Autenticação**: Bearer token (JWT do usuário)

**Body**:
```json
{
  "planId": "uuid",
  "billingCycle": "monthly" | "yearly",
  "paymentMethod": "pix" | "boleto" | "credit_card"
}
```

**Resposta**:
```json
{
  "success": true,
  "data": {
    "subscription": {
      "id": "uuid",
      "user_id": "uuid",
      "status": "pending",
      ...
    },
    "payment": {
      "invoiceUrl": "https://...",
      "pixQrCode": "data:image/png;base64,...",
      "pixCopyPaste": "00020126...",
      "dueDate": "2024-01-08",
      "value": 99.90,
      "paymentMethod": "pix"
    },
    "asaas": {
      "subscriptionId": "sub_xxx",
      "customerId": "cus_xxx"
    }
  }
}
```

**Fluxo**:
1. Valida usuário autenticado
2. Busca plano no banco
3. Verifica se já tem assinatura ativa
4. Cria/busca cliente no Asaas
5. Cria assinatura no Asaas
6. Registra assinatura local
7. Registra primeira transação
8. Retorna dados de pagamento

---

### 2. `handle-asaas-webhook`

Processa webhooks enviados pelo Asaas quando o status de pagamentos muda.

**Endpoint**: `POST /functions/v1/handle-asaas-webhook`

**Autenticação**: Nenhuma (webhook público)

**Body** (enviado pelo Asaas):
```json
{
  "event": "PAYMENT_RECEIVED",
  "payment": {
    "id": "pay_xxx",
    "customer": "cus_xxx",
    "subscription": "sub_xxx",
    "value": 99.90,
    "status": "RECEIVED",
    "dueDate": "2024-01-01",
    "paymentDate": "2024-01-01",
    ...
  }
}
```

**Resposta**:
```json
{
  "success": true,
  "data": {
    "processed": true,
    "eventType": "PAYMENT_RECEIVED",
    "transactionId": "uuid",
    "oldStatus": "pending",
    "newStatus": "received"
  }
}
```

**Eventos Suportados**:
- `PAYMENT_CREATED`: Pagamento criado
- `PAYMENT_CONFIRMED`: Pagamento confirmado (aguardando compensação)
- `PAYMENT_RECEIVED`: Pagamento recebido (compensado) → **Ativa assinatura**
- `PAYMENT_OVERDUE`: Pagamento vencido → **Marca assinatura como past_due**
- `PAYMENT_REFUNDED`: Pagamento estornado → **Cancela assinatura**
- Outros eventos (ver código)

**Fluxo**:
1. Recebe webhook do Asaas
2. Busca transação no banco
3. Atualiza status da transação
4. Se pagamento recebido: ativa assinatura
5. Se pagamento vencido: marca assinatura como past_due
6. Se pagamento estornado: cancela assinatura

---

### 3. `cancel-subscription`

Cancela uma assinatura ativa do usuário.

**Endpoint**: `POST /functions/v1/cancel-subscription`

**Autenticação**: Bearer token (JWT do usuário)

**Body**:
```json
{
  "subscriptionId": "uuid",
  "immediate": false,
  "reason": "Não preciso mais do serviço"
}
```

**Parâmetros**:
- `subscriptionId` (obrigatório): UUID da assinatura
- `immediate` (opcional, padrão: `false`): Se `true`, cancela imediatamente. Se `false`, cancela ao fim do período.
- `reason` (opcional): Motivo do cancelamento

**Resposta**:
```json
{
  "success": true,
  "data": {
    "subscription": { ... },
    "canceledAt": "2024-01-02T10:30:00Z",
    "immediate": false,
    "endsAt": "2024-02-01T00:00:00Z",
    "message": "Assinatura será cancelada ao fim do período atual"
  }
}
```

**Fluxo**:
1. Valida usuário autenticado
2. Busca assinatura (verifica se pertence ao usuário)
3. Cancela no Asaas
4. Se `immediate=true`:
   - Status → `canceled`
   - Acesso removido imediatamente
5. Se `immediate=false`:
   - `cancel_at_period_end` → `true`
   - Acesso continua até `current_period_end`

---

### 4. `get-subscription-status`

Retorna o status completo da assinatura do usuário.

**Endpoint**: `GET /functions/v1/get-subscription-status`

**Autenticação**: Bearer token (JWT do usuário)

**Resposta** (com assinatura ativa):
```json
{
  "success": true,
  "data": {
    "hasActiveSubscription": true,
    "isPremium": true,
    "subscription": {
      "id": "uuid",
      "status": "active",
      "planName": "Clube dos 100 - Mensal",
      "billingCycle": "monthly",
      "currentPeriodStart": "2024-01-01T00:00:00Z",
      "currentPeriodEnd": "2024-02-01T00:00:00Z",
      "cancelAtPeriodEnd": false,
      "canceledAt": null,
      "createdAt": "2024-01-01T00:00:00Z"
    },
    "plan": {
      "id": "uuid",
      "name": "Clube dos 100 - Mensal",
      "description": "Plano mensal com benefícios exclusivos",
      "priceMonthly": 99.90,
      "priceYearly": 959.04,
      "features": ["unlimited_posts", "priority_support"],
      "maxServicesPerMonth": null,
      "maxContractorsContacted": null
    },
    "features": ["unlimited_posts", "priority_support"],
    "usage": {
      "servicesThisMonth": 5,
      "maxServices": null,
      "percentageUsed": 0
    },
    "payments": {
      "history": [
        {
          "id": "uuid",
          "amount": 99.90,
          "status": "received",
          "payment_date": "2024-01-01T00:00:00Z",
          "payment_method": "pix"
        }
      ],
      "next": {
        "dueDate": "2024-02-01",
        "amount": 99.90,
        "paymentMethod": "pix"
      }
    }
  }
}
```

**Resposta** (sem assinatura):
```json
{
  "success": true,
  "data": {
    "hasActiveSubscription": false,
    "isPremium": false,
    "subscription": null,
    "plan": null,
    "features": [],
    "usage": {
      "servicesThisMonth": 0,
      "maxServices": null
    }
  }
}
```

**Fluxo**:
1. Valida usuário autenticado
2. Chama função PostgreSQL `check_subscription_status()`
3. Busca detalhes completos da assinatura
4. Calcula uso do mês atual
5. Busca histórico de pagamentos
6. Retorna dados completos

---

## 🔧 Shared Utilities

### `_shared/asaas-api.ts`

Cliente para integração com a API do Asaas.

**Funções Principais**:
- `createOrUpdateAsaasCustomer()`: Criar/atualizar cliente
- `findAsaasCustomerByCpfCnpj()`: Buscar cliente por CPF/CNPJ
- `createAsaasSubscription()`: Criar assinatura
- `cancelAsaasSubscription()`: Cancelar assinatura
- `getAsaasSubscription()`: Buscar assinatura
- `getAsaasPayment()`: Buscar pagamento
- `getAsaasPixQrCode()`: Gerar QR Code PIX
- `getNextDueDate()`: Calcular próxima data de vencimento
- `getNextPeriodEnd()`: Calcular fim do período
- `convertBillingCycleToAsaas()`: Converter billing cycle
- `convertPaymentMethodToAsaas()`: Converter payment method
- `cleanCpfCnpj()`: Limpar CPF/CNPJ

**Interfaces**:
- `AsaasCustomerData`: Dados do cliente
- `AsaasSubscriptionData`: Dados da assinatura
- `AsaasPaymentData`: Dados de cobrança

### `_shared/supabase-client.ts`

Utilidades para Edge Functions Supabase.

**Funções Principais**:
- `createServiceClient()`: Criar cliente com service role
- `getAuthenticatedUser()`: Obter usuário do JWT
- `successResponse()`: Criar resposta de sucesso
- `errorResponse()`: Criar resposta de erro
- `validateRequiredFields()`: Validar campos obrigatórios
- `logInfo()`: Log de informação
- `logError()`: Log de erro

---

## 🔐 Environment Variables

As Edge Functions precisam das seguintes variáveis de ambiente:

```env
# Supabase
SUPABASE_URL=https://supa.rupies.com.br
SUPABASE_SERVICE_ROLE_KEY=eyJ0eXAiOiJKV1Qi...

# Asaas
ASAAS_API_KEY=your_asaas_api_key_here
ASAAS_ENVIRONMENT=sandbox  # ou 'production'
```

**Configurar via CLI**:
```bash
supabase secrets set ASAAS_API_KEY=your_key_here
supabase secrets set ASAAS_ENVIRONMENT=sandbox
```

---

## 🧪 Testing

### Test Localmente

```bash
# Servir todas as functions
supabase functions serve --env-file supabase/.env

# Test create-asaas-subscription
curl -X POST http://localhost:54321/functions/v1/create-asaas-subscription \
  -H "Authorization: Bearer YOUR_JWT" \
  -H "Content-Type: application/json" \
  -d '{"planId":"uuid","billingCycle":"monthly","paymentMethod":"pix"}'

# Test get-subscription-status
curl http://localhost:54321/functions/v1/get-subscription-status \
  -H "Authorization: Bearer YOUR_JWT"
```

### Ver Logs

```bash
# Logs de uma function específica
supabase functions logs create-asaas-subscription --follow

# Logs de todas as functions
supabase functions logs --all --follow
```

---

## 📦 Deploy

```bash
# Deploy todas as functions
supabase functions deploy create-asaas-subscription
supabase functions deploy handle-asaas-webhook
supabase functions deploy cancel-subscription
supabase functions deploy get-subscription-status
```

Ver guia completo: [EDGE_FUNCTIONS_DEPLOY.md](../EDGE_FUNCTIONS_DEPLOY.md)

---

## 🔗 Webhook Configuration

Configurar webhook no Asaas apontando para:

```
https://supa.rupies.com.br/functions/v1/handle-asaas-webhook
```

Eventos:
- ✅ PAYMENT_CREATED
- ✅ PAYMENT_CONFIRMED
- ✅ PAYMENT_RECEIVED
- ✅ PAYMENT_OVERDUE
- ✅ PAYMENT_REFUNDED

---

## 📊 Arquitetura

```
┌─────────────────┐
│  Flutter App    │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────┐
│     Supabase Edge Functions         │
│  ┌────────────────────────────────┐ │
│  │ create-asaas-subscription      │ │
│  │ cancel-subscription            │ │
│  │ get-subscription-status        │ │
│  └────────────────────────────────┘ │
│                                     │
│  ┌────────────────────────────────┐ │
│  │ handle-asaas-webhook ◄──────┐  │ │
│  └────────────────────────────────┘ │
└───────────┬─────────────────────────┘
            │                         │
            ▼                         │
    ┌──────────────┐                  │
    │  Asaas API   │──────────────────┘
    └──────────────┘                Webhook
```

---

## 📖 Referencias

- [Documentação Supabase Edge Functions](https://supabase.com/docs/guides/functions)
- [Documentação Asaas API](https://docs.asaas.com/reference)
- [Deno Deploy](https://deno.com/deploy)

---

**Versão**: 1.0
**Criado**: 2025-01-02
**Status**: ✅ Pronto para uso
