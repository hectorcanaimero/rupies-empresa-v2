# 🚀 Deploy Edge Functions - Clube dos 100

Guía completa para deployar las Edge Functions de integración con Asaas.

---

## 📋 Prerequisitos

### 1. Supabase CLI Instalado

```bash
# Instalar Supabase CLI
npm install -g supabase

# Verificar instalación
supabase --version
```

### 2. Deno Instalado (para Edge Functions)

```bash
# macOS/Linux
curl -fsSL https://deno.land/install.sh | sh

# Windows (PowerShell)
irm https://deno.land/install.ps1 | iex

# Verificar instalación
deno --version
```

### 3. Credenciales de Supabase

Necesitas:
- **Project Reference ID**: Obtén en Dashboard → Settings → General
- **Access Token**: Genera en Dashboard → Settings → API → Personal access tokens

---

## 🔧 Configuración Inicial

### 1. Login en Supabase CLI

```bash
# Login con tu cuenta Supabase
supabase login

# Verificar link del proyecto
supabase link --project-ref <YOUR_PROJECT_REF>
```

### 2. Configurar Variables de Entorno

#### Copiar archivo de ejemplo

```bash
cd supabase
cp .env.example .env
```

#### Editar archivo `.env`

```bash
# Abrir con tu editor favorito
nano .env
# o
code .env
```

#### Llenar las variables:

```env
# Supabase
SUPABASE_URL=https://supa.rupies.com.br
SUPABASE_ANON_KEY=eyJ0eXAiOiJKV1Qi... # Tu anon key
SUPABASE_SERVICE_ROLE_KEY=eyJ0eXAiOiJKV1Qi... # Tu service role key

# Asaas
ASAAS_API_KEY=your_asaas_api_key_here
ASAAS_ENVIRONMENT=sandbox  # o 'production'

# Webhook
WEBHOOK_URL=https://supa.rupies.com.br/functions/v1/handle-asaas-webhook
```

**Importante**: NUNCA commitear el archivo `.env` al Git (ya está en `.gitignore`).

---

## 📦 Estrutura das Edge Functions

```
supabase/
├── functions/
│   ├── _shared/                       # Utilities compartidas
│   │   ├── asaas-api.ts              # Cliente API Asaas
│   │   └── supabase-client.ts        # Cliente Supabase
│   │
│   ├── create-asaas-subscription/    # Crear assinatura
│   │   └── index.ts
│   │
│   ├── handle-asaas-webhook/         # Receber webhooks
│   │   └── index.ts
│   │
│   ├── cancel-subscription/          # Cancelar assinatura
│   │   └── index.ts
│   │
│   └── get-subscription-status/      # Consultar status
│       └── index.ts
│
├── .env.example                       # Template de variables
├── .env                              # Variables (NUNCA commit)
└── .gitignore                        # Proteger .env
```

---

## 🚀 Deploy das Edge Functions

### Opção 1: Deploy Individual

```bash
# Deploy de uma function específica
supabase functions deploy create-asaas-subscription
supabase functions deploy handle-asaas-webhook
supabase functions deploy cancel-subscription
supabase functions deploy get-subscription-status
```

### Opção 2: Deploy de Todas as Functions

```bash
# Deploy todas de uma vez
supabase functions deploy create-asaas-subscription && \
supabase functions deploy handle-asaas-webhook && \
supabase functions deploy cancel-subscription && \
supabase functions deploy get-subscription-status
```

### Opção 3: Script de Deploy

Criar arquivo `deploy-functions.sh`:

```bash
#!/bin/bash

echo "🚀 Deployando Edge Functions..."

functions=(
  "create-asaas-subscription"
  "handle-asaas-webhook"
  "cancel-subscription"
  "get-subscription-status"
)

for func in "${functions[@]}"; do
  echo ""
  echo "📦 Deployando: $func"
  supabase functions deploy "$func"

  if [ $? -eq 0 ]; then
    echo "✅ $func deployed com sucesso"
  else
    echo "❌ Erro ao deployar $func"
    exit 1
  fi
done

echo ""
echo "🎉 Todas as Edge Functions foram deployadas!"
```

Tornar executável e rodar:

```bash
chmod +x deploy-functions.sh
./deploy-functions.sh
```

---

## 🔐 Configurar Secrets (Variables de Entorno no Supabase)

As Edge Functions precisam de secrets configuradas no Supabase.

### Setear Secrets via CLI

```bash
# Asaas API Key
supabase secrets set ASAAS_API_KEY=your_asaas_api_key_here

# Asaas Environment
supabase secrets set ASAAS_ENVIRONMENT=sandbox

# Verificar secrets configuradas
supabase secrets list
```

### Setear Secrets via Dashboard

1. Abrir: https://supa.rupies.com.br/project/_/settings/functions
2. Seção **"Edge Function Secrets"**
3. Adicionar:
   - `ASAAS_API_KEY`: Sua API key do Asaas
   - `ASAAS_ENVIRONMENT`: `sandbox` ou `production`

---

## 🧪 Testar Edge Functions Localmente

### 1. Iniciar Supabase Local

```bash
# Iniciar stack local do Supabase
supabase start
```

### 2. Servir Edge Functions Localmente

```bash
# Servir todas as functions
supabase functions serve

# Servir uma function específica
supabase functions serve create-asaas-subscription --env-file supabase/.env
```

### 3. Testar com cURL

#### Test: create-asaas-subscription

```bash
curl -X POST http://localhost:54321/functions/v1/create-asaas-subscription \
  -H "Authorization: Bearer YOUR_USER_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "planId": "uuid-do-plano",
    "billingCycle": "monthly",
    "paymentMethod": "pix"
  }'
```

#### Test: get-subscription-status

```bash
curl -X GET http://localhost:54321/functions/v1/get-subscription-status \
  -H "Authorization: Bearer YOUR_USER_JWT_TOKEN"
```

#### Test: cancel-subscription

```bash
curl -X POST http://localhost:54321/functions/v1/cancel-subscription \
  -H "Authorization: Bearer YOUR_USER_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "subscriptionId": "uuid-da-assinatura",
    "immediate": false,
    "reason": "Teste de cancelamento"
  }'
```

#### Test: handle-asaas-webhook (simular webhook)

```bash
curl -X POST http://localhost:54321/functions/v1/handle-asaas-webhook \
  -H "Content-Type: application/json" \
  -d '{
    "event": "PAYMENT_RECEIVED",
    "payment": {
      "id": "pay_xxx",
      "customer": "cus_xxx",
      "subscription": "sub_xxx",
      "value": 99.90,
      "status": "RECEIVED",
      "dueDate": "2024-01-01",
      "paymentDate": "2024-01-01"
    }
  }'
```

---

## 🔗 Configurar Webhook no Asaas

Após deployar as functions, configure o webhook no Asaas.

### Sandbox

1. Login: https://sandbox.asaas.com
2. Menu: **Configurações → Webhooks**
3. **Nova Configuração de Webhook**
4. URL: `https://supa.rupies.com.br/functions/v1/handle-asaas-webhook`
5. Eventos a habilitar:
   - ✅ `PAYMENT_CREATED`
   - ✅ `PAYMENT_UPDATED`
   - ✅ `PAYMENT_CONFIRMED`
   - ✅ `PAYMENT_RECEIVED`
   - ✅ `PAYMENT_OVERDUE`
   - ✅ `PAYMENT_DELETED`
   - ✅ `PAYMENT_REFUNDED`
6. Salvar

### Production

Mesmos passos, mas em: https://www.asaas.com

---

## 📊 Monitoramento e Logs

### Ver Logs das Edge Functions

```bash
# Logs em tempo real de uma function
supabase functions logs create-asaas-subscription --follow

# Logs de todas as functions
supabase functions logs --all --follow
```

### Ver Logs via Dashboard

1. Abrir: https://supa.rupies.com.br/project/_/logs/edge-functions
2. Selecionar function específica
3. Filtrar por level: Info, Error, etc.

---

## 🚨 Troubleshooting

### Error: "Command not found: supabase"

```bash
# Instalar Supabase CLI
npm install -g supabase
```

### Error: "Not linked to any Supabase project"

```bash
# Fazer link do projeto
supabase link --project-ref <YOUR_PROJECT_REF>
```

### Error: "ASAAS_API_KEY não configurado"

```bash
# Setar secret no Supabase
supabase secrets set ASAAS_API_KEY=your_key_here
```

### Error: "Erro ao criar assinatura Asaas"

1. Verificar se API key é válida
2. Verificar se está usando sandbox ou production correto
3. Ver logs detalhados: `supabase functions logs create-asaas-subscription`

### Error: Webhook não recebe eventos

1. Verificar URL configurada no Asaas
2. Testar manualmente com cURL
3. Verificar logs: `supabase functions logs handle-asaas-webhook`
4. Verificar se function está deployed: `supabase functions list`

---

## ✅ Checklist de Deployment

Antes de ir para produção:

- [ ] Supabase CLI instalado e configurado
- [ ] Deno instalado
- [ ] Link do projeto feito: `supabase link`
- [ ] Arquivo `.env` configurado (não commitado)
- [ ] Secrets configuradas no Supabase:
  - [ ] `ASAAS_API_KEY`
  - [ ] `ASAAS_ENVIRONMENT`
- [ ] Edge Functions deployadas:
  - [ ] `create-asaas-subscription`
  - [ ] `handle-asaas-webhook`
  - [ ] `cancel-subscription`
  - [ ] `get-subscription-status`
- [ ] Testes locais realizados
- [ ] Webhook configurado no Asaas (sandbox primeiro)
- [ ] Teste end-to-end completo:
  - [ ] Criar assinatura
  - [ ] Receber webhook de pagamento
  - [ ] Consultar status
  - [ ] Cancelar assinatura
- [ ] Logs monitorados sem erros
- [ ] Mudar `ASAAS_ENVIRONMENT` para `production`
- [ ] Configurar webhook no Asaas production

---

## 📖 Próximos Passos

Após deployment bem-sucedido:

1. **Fase 3**: Implementar UI Flutter
   - Tela de planos
   - Tela de checkout
   - Tela de gerenciamento de assinatura

2. **Testes em Sandbox**
   - Criar assinatura de teste
   - Simular pagamento PIX
   - Simular pagamento Boleto
   - Testar cancelamento

3. **Go Live**
   - Mudar para production
   - Configurar webhook production
   - Monitorar primeiras assinaturas

---

## 📞 Suporte

- **Documentação Supabase Edge Functions**: https://supabase.com/docs/guides/functions
- **Documentação Asaas API**: https://docs.asaas.com/reference
- **Logs**: `supabase functions logs --all`

---

**Criado**: 2025-01-02
**Versão**: 1.0
**Status**: ✅ Pronto para deploy
