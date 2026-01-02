# 🚀 Setup Completo - Edge Functions Local + Production

## ✅ Lo Que Ya Está Configurado

1. ✅ Supabase CLI instalado
2. ✅ Edge Functions deployadas en production
3. ✅ Configuración local (`config.toml`) actualizada
4. ✅ Variables SUPABASE configuradas en `.env.local`

---

## ⚠️  Falta Solo 1 Cosa: Asaas API Key

### Paso 1: Obtener Asaas API Key (Sandbox)

1. **Crear cuenta Asaas Sandbox** (si no tienes):
   - Ir a: https://sandbox.asaas.com/
   - Crear cuenta gratis

2. **Obtener API Key**:
   - Login: https://sandbox.asaas.com
   - Menu: **Configurações** → **Integrações** → **API Key**
   - O directo: https://sandbox.asaas.com/config/api
   - Click **"Gerar nova chave"** si no tienes una
   - **Copiar** la API key (empieza con algo como `$aact_...`)

### Paso 2: Configurar en `.env.local`

Edita el archivo:
```bash
nano supabase/.env.local
```

O abrelo en tu editor y cambia:
```bash
ASAAS_API_KEY=PEGA_TU_ASAAS_API_KEY_AQUI
```

Por:
```bash
ASAAS_API_KEY=$aact_YTU5YTE0M2M2N2I4MTliNzk0YTI5N2U5MzdjNWZmNDQ6OjAwMDAwMDAwMDAwMDAwNDU5MzI6OiRhYWNoXzE2OGQyOGI0LWU3YmUtNDA5MS1hMjE2LTk2MTk0OTk0MDBhYg==
```
(Reemplaza con TU key real de Asaas)

Guarda el archivo.

---

## 🧪 Test Local (Desarrollo)

### Opción 1: Servir Edge Functions Localmente

```bash
cd /Users/al3jandro/project/rupies/rupies-empresa
supabase functions serve --env-file supabase/.env.local
```

**Resultado esperado**:
```
Serving functions on http://127.0.0.1:54321/functions/v1/
  - create-asaas-subscription
  - handle-asaas-webhook
  - cancel-subscription
  - get-subscription-status
```

### Test Local

En otro terminal:
```bash
# Test get-subscription-status (sin auth, debe dar error de auth)
curl http://127.0.0.1:54321/functions/v1/get-subscription-status
```

**Resultado esperado**:
```json
{
  "success": false,
  "error": "Authorization header não encontrado"
}
```

✅ Si ves este error = **¡Funciona! Solo falta auth**
❌ Si ves `"Invalid supabaseUrl"` = **Faltan secrets**

---

## 🌐 Test Production (Deployado)

### Configurar Secrets en Production

Como tu Supabase está en `supa.rupies.com.br`, necesitas configurar secrets vía Dashboard.

**Método 1: Via Dashboard** (Recomendado)

1. Abrir: `https://supa.rupies.com.br/project/_/settings/functions`
2. Buscar "Edge Function Secrets"
3. Agregar:
   ```
   SUPABASE_URL = https://supa.rupies.com.br
   SUPABASE_SERVICE_ROLE_KEY = eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzdXBhYmFzZSIsImlhdCI6MTc0NzE2NTIwMCwiZXhwIjo0OTAyODM4ODAwLCJyb2xlIjoic2VydmljZV9yb2xlIn0.LSlDYxZgbQWsdB0w_vEsu2vD4AM6nhYSoW4IZnMaink
   ASAAS_API_KEY = $aact_... (tu key)
   ASAAS_ENVIRONMENT = sandbox
   ```
4. Guardar

### Test Production

```bash
cd supabase
./test-edge-functions.sh
```

**Resultado esperado** (después de configurar):
```
✅ Function deployada correctamente
✅ Secrets configurados
⚠️  Falta token de autenticación (esperado)
```

---

## 📋 Configurar Webhook Asaas

Después de que las functions funcionen:

### Sandbox (Testing)

1. Login: https://sandbox.asaas.com
2. Menu: **Configurações** → **Webhooks**
3. **URL**: `https://supa.rupies.com.br/functions/v1/handle-asaas-webhook`
4. **Eventos** (marcar todos):
   - ✅ PAYMENT_CREATED
   - ✅ PAYMENT_UPDATED
   - ✅ PAYMENT_CONFIRMED
   - ✅ PAYMENT_RECEIVED
   - ✅ PAYMENT_OVERDUE
   - ✅ PAYMENT_DELETED
   - ✅ PAYMENT_REFUNDED
5. **Salvar**

### Verificar Webhook

Crear una cobrança test en Asaas y verificar que el webhook llega:
```bash
# Ver logs en tiempo real
tail -f /var/log/supabase/edge-functions.log
```

O via Dashboard: Edge Functions → Logs

---

## 🎯 Comandos Útiles

### Desarrollo Local

```bash
# Servir functions localmente
supabase functions serve --env-file supabase/.env.local

# Con logs detallados
supabase functions serve --env-file supabase/.env.local --debug

# Test una function específica
curl http://127.0.0.1:54321/functions/v1/get-subscription-status
```

### Production

```bash
# Ver logs de production
supabase functions logs get-subscription-status --follow

# Test production
./test-edge-functions.sh

# Deploy cambios
supabase functions deploy create-asaas-subscription
```

### Test con Usuario Real

```bash
# Obtener JWT token de un usuario
# En SQL Editor:
SELECT auth.sign_in_with_email_password(
  'usuario@example.com',
  'password123'
);

# Copiar el access_token y testar:
curl "https://supa.rupies.com.br/functions/v1/get-subscription-status" \
  -H "Authorization: Bearer eyJhbGc..."
```

---

## 🚨 Troubleshooting

### Error: "Invalid supabaseUrl"
**Causa**: Secrets no configurados
**Solución**: Configurar via Dashboard o `.env.local`

### Error: "ASAAS_API_KEY não configurado"
**Causa**: Falta API key de Asaas
**Solución**: Agregar en `.env.local` (local) o Dashboard (production)

### Error: "Cannot connect to Asaas API"
**Causa**: API key inválida
**Solución**: Verificar que la key sea correcta en Asaas sandbox

### Functions no levantan localmente
```bash
# Verificar que Deno está instalado
deno --version

# Reinstalar si es necesario
brew install deno
```

### Secrets no se cargan
```bash
# Verificar archivo .env.local
cat supabase/.env.local

# Verificar config.toml
cat supabase/config.toml | grep -A 5 "edge_runtime.secrets"
```

---

## ✅ Checklist de Setup

- [x] Supabase CLI instalado
- [x] Edge Functions deployadas
- [x] config.toml actualizado con secrets
- [x] SUPABASE_URL en .env.local
- [x] SUPABASE_SERVICE_ROLE_KEY en .env.local
- [ ] **ASAAS_API_KEY en .env.local** ← **HACER AHORA**
- [ ] ASAAS_ENVIRONMENT en .env.local (ya está)
- [ ] Configurar secrets en Production Dashboard
- [ ] Test local funciona
- [ ] Test production funciona
- [ ] Webhook Asaas configurado

---

## 🎉 Próximos Pasos

Después de completar el setup:

1. **Test End-to-End**:
   - Crear assinatura de prueba
   - Verificar que genera payment link
   - Simular pago en Asaas sandbox
   - Verificar que webhook actualiza DB

2. **Fase 3: Flutter UI**:
   - Pantalla de planos
   - Pantalla de checkout (PIX/Boleto)
   - Pantalla de gerenciamento
   - Custom actions de integración

---

## 📖 Archivos de Referencia

- **[CONFIGURAR_SECRETS.md](./CONFIGURAR_SECRETS.md)** - Guía detallada de secrets
- **[test-edge-functions.sh](./test-edge-functions.sh)** - Script de testing
- **[STATUS_DEPLOYMENT.md](./STATUS_DEPLOYMENT.md)** - Status actual
- **[.env.local](./env.local)** - Tus secrets locales (no commitear)

---

**Creado**: 2025-01-02
**Status**: Configuración casi completa, solo falta Asaas API Key
**Tiempo estimado**: 5 minutos para completar
