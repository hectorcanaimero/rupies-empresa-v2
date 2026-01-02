# 🔐 Configurar Secrets - Edge Functions

## ✅ Estado Actual

Las Edge Functions están **deployadas correctamente** en:
```
https://supa.rupies.com.br/functions/v1/
```

**Problema detectado**: Faltan secrets de entorno.

Error actual:
```
"Invalid supabaseUrl: Must be a valid HTTP or HTTPS URL."
```

---

## 🔧 Secrets Requeridos

Las Edge Functions necesitan estos secrets configurados en Supabase:

### 1. SUPABASE_URL
```
SUPABASE_URL=https://supa.rupies.com.br
```

### 2. SUPABASE_SERVICE_ROLE_KEY
```
SUPABASE_SERVICE_ROLE_KEY=eyJ0eXAiOiJKV1Qi...
```
**Obtener en**: Dashboard → Settings → API → `service_role` key

### 3. ASAAS_API_KEY
```
ASAAS_API_KEY=your_asaas_api_key_here
```
**Obtener en**:
- Sandbox: https://sandbox.asaas.com/config/api
- Production: https://www.asaas.com/config/api

### 4. ASAAS_ENVIRONMENT
```
ASAAS_ENVIRONMENT=sandbox
```
Opciones: `sandbox` o `production`

---

## 📋 Método 1: Via Dashboard (Recomendado)

### Paso 1: Abrir Edge Functions Settings

```
https://supa.rupies.com.br/project/_/settings/functions
```

O navegar:
1. Dashboard de Supabase
2. Settings (engranaje)
3. Edge Functions
4. Secrets

### Paso 2: Agregar Secrets

Agregar cada secret con su valor:

| Secret Name | Valor |
|-------------|-------|
| `SUPABASE_URL` | `https://supa.rupies.com.br` |
| `SUPABASE_SERVICE_ROLE_KEY` | Tu service_role key |
| `ASAAS_API_KEY` | Tu Asaas API key |
| `ASAAS_ENVIRONMENT` | `sandbox` |

### Paso 3: Guardar

Click "Save" o "Add secret" para cada uno.

---

## 📋 Método 2: Via CLI (Si el proyecto está linkeado)

Si has linkeado el proyecto (`supabase link`):

```bash
# Configurar secrets
supabase secrets set SUPABASE_URL="https://supa.rupies.com.br"
supabase secrets set SUPABASE_SERVICE_ROLE_KEY="eyJ0eXAi..."
supabase secrets set ASAAS_API_KEY="your_asaas_key"
supabase secrets set ASAAS_ENVIRONMENT="sandbox"

# Verificar
supabase secrets list
```

---

## 📋 Método 3: Via SQL (Alternativo)

Si tienes acceso al SQL Editor:

```sql
-- NO RECOMENDADO: Los secrets deben estar en el nivel de Edge Functions,
-- no en el database. Usar Método 1 o 2.
```

---

## ✅ Verificar Configuración

Después de configurar los secrets, testar:

### Test 1: Health Check

```bash
curl "https://supa.rupies.com.br/functions/v1/get-subscription-status"
```

**Esperado (sin auth)**:
```json
{
  "success": false,
  "error": "Authorization header não encontrado"
}
```

**NO esperado**:
```json
{
  "success": false,
  "error": "Invalid supabaseUrl..."
}
```

### Test 2: Con Token de Usuario

Necesitas un JWT token de un usuario autenticado.

**Obtener token**:
1. Login en el app
2. Extraer token del localStorage o cookies
3. O generar via SQL:

```sql
-- En SQL Editor de Supabase
SELECT auth.sign_in_with_email_password(
  'usuario@example.com',
  'password123'
);
-- Copiar el access_token
```

**Test**:
```bash
curl "https://supa.rupies.com.br/functions/v1/get-subscription-status" \
  -H "Authorization: Bearer eyJhbGc..."
```

**Esperado**:
```json
{
  "success": true,
  "data": {
    "hasActiveSubscription": false,
    "isPremium": false,
    ...
  }
}
```

---

## 🚨 Troubleshooting

### Error: "Invalid supabaseUrl"
**Causa**: `SUPABASE_URL` no está configurado
**Solución**: Configurar via Dashboard (Método 1)

### Error: "SUPABASE_SERVICE_ROLE_KEY não configurados"
**Causa**: Service role key faltante
**Solución**: Obtener en Dashboard → Settings → API → service_role

### Error: "ASAAS_API_KEY não configurado"
**Causa**: Asaas key faltante
**Solución**: Obtener en https://sandbox.asaas.com/config/api

### Error: "Authorization header não encontrado"
**Causa**: No se envió el JWT token
**Solución**: Agregar `-H "Authorization: Bearer YOUR_JWT"`
**Nota**: Este error es NORMAL si no mandas token

### Error: "Usuário não autenticado"
**Causa**: JWT token inválido o expirado
**Solución**: Generar nuevo token

---

## 📊 URLs de las Functions Deployadas

Después de configurar secrets, estas URLs estarán disponibles:

### 1. Get Subscription Status
```
GET https://supa.rupies.com.br/functions/v1/get-subscription-status
Authorization: Bearer <user-jwt>
```

### 2. Create Asaas Subscription
```
POST https://supa.rupies.com.br/functions/v1/create-asaas-subscription
Authorization: Bearer <user-jwt>
Content-Type: application/json

{
  "planId": "uuid",
  "billingCycle": "monthly",
  "paymentMethod": "pix"
}
```

### 3. Cancel Subscription
```
POST https://supa.rupies.com.br/functions/v1/cancel-subscription
Authorization: Bearer <user-jwt>
Content-Type: application/json

{
  "subscriptionId": "uuid",
  "immediate": false,
  "reason": "Não preciso mais"
}
```

### 4. Handle Asaas Webhook
```
POST https://supa.rupies.com.br/functions/v1/handle-asaas-webhook
Content-Type: application/json

{
  "event": "PAYMENT_RECEIVED",
  "payment": { ... }
}
```

**Nota**: Esta URL es pública (no requiere auth) porque es llamada por Asaas.

---

## 🔗 Configurar Webhook en Asaas

Después de configurar secrets, configurar webhook:

### Sandbox (Testing)

1. Login: https://sandbox.asaas.com
2. Configurações → Webhooks
3. Nova Configuração
4. **URL**: `https://supa.rupies.com.br/functions/v1/handle-asaas-webhook`
5. **Eventos**:
   - ✅ PAYMENT_CREATED
   - ✅ PAYMENT_CONFIRMED
   - ✅ PAYMENT_RECEIVED
   - ✅ PAYMENT_OVERDUE
   - ✅ PAYMENT_REFUNDED
6. Salvar

### Production (Depois dos testes)

Mesmos passos, mas em: https://www.asaas.com

---

## 📖 Próximos Pasos

Después de configurar secrets:

1. ✅ Configurar secrets (Este documento)
2. 🧪 Testar endpoints
3. 🔗 Configurar webhook Asaas
4. 📱 Integrar con Flutter (Fase 3)

---

**Creado**: 2025-01-02
**Status**: Secrets pendientes de configuración
**Prioridad**: 🔴 Alta (requerido para funcionamiento)
