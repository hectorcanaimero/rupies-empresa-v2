# 📊 Status Deployment - Edge Functions

**Fecha**: 2025-01-02
**Estado**: ✅ Deployadas / ⚠️ Pendiente Configuración

---

## ✅ Lo Que Funciona

### 1. Edge Functions Deployadas
**Status**: ✅ **Todas las 4 functions están deployadas**

| Function | URL | Status |
|----------|-----|--------|
| get-subscription-status | `/functions/v1/get-subscription-status` | ✅ Deployada |
| create-asaas-subscription | `/functions/v1/create-asaas-subscription` | ✅ Deployada |
| cancel-subscription | `/functions/v1/cancel-subscription` | ✅ Deployada |
| handle-asaas-webhook | `/functions/v1/handle-asaas-webhook` | ✅ Deployada |

**Base URL**: `https://supa.rupies.com.br/functions/v1/`

**Verificación**:
```bash
cd supabase
./test-edge-functions.sh
```

---

## ⚠️ Pendiente de Configuración

### Secrets de Environment

**Status**: ❌ **Faltan secrets**

**Error actual**:
```json
{
  "success": false,
  "error": "Invalid supabaseUrl: Must be a valid HTTP or HTTPS URL."
}
```

**Secrets requeridos**:

| Secret | Descripción | Dónde obtener |
|--------|-------------|---------------|
| `SUPABASE_URL` | URL de Supabase | `https://supa.rupies.com.br` |
| `SUPABASE_SERVICE_ROLE_KEY` | Service role key | Dashboard → Settings → API |
| `ASAAS_API_KEY` | API key de Asaas | https://sandbox.asaas.com/config/api |
| `ASAAS_ENVIRONMENT` | Entorno Asaas | `sandbox` o `production` |

---

## 📋 Próximos Pasos

### Paso 1: Configurar Secrets ⚠️ URGENTE

**Guía completa**: [CONFIGURAR_SECRETS.md](./CONFIGURAR_SECRETS.md)

**Método rápido (Dashboard)**:
1. Abrir: `https://supa.rupies.com.br/project/_/settings/functions`
2. Sección "Edge Function Secrets"
3. Agregar los 4 secrets listados arriba
4. Guardar

**Tiempo estimado**: 5 minutos

### Paso 2: Verificar Funcionamiento

Ejecutar test script:
```bash
cd supabase
./test-edge-functions.sh
```

**Resultado esperado** (después de configurar secrets):
```
✅ Function deployada correctamente
✅ Secrets configurados
⚠️  Falta token de autenticación (esperado)
```

### Paso 3: Configurar Webhook Asaas

**URL del webhook**:
```
https://supa.rupies.com.br/functions/v1/handle-asaas-webhook
```

**Configuración**:
1. Login: https://sandbox.asaas.com
2. Configurações → Webhooks
3. Nova Configuração
4. URL: (copiar la de arriba)
5. Eventos: Todos los `PAYMENT_*`
6. Salvar

**Tiempo estimado**: 3 minutos

### Paso 4: Test End-to-End

**Crear assinatura de prueba**:
```bash
curl -X POST "https://supa.rupies.com.br/functions/v1/create-asaas-subscription" \
  -H "Authorization: Bearer YOUR_USER_JWT" \
  -H "Content-Type: application/json" \
  -d '{
    "planId": "uuid-do-plano-gratis",
    "billingCycle": "monthly",
    "paymentMethod": "pix"
  }'
```

**Consultar status**:
```bash
curl "https://supa.rupies.com.br/functions/v1/get-subscription-status" \
  -H "Authorization: Bearer YOUR_USER_JWT"
```

---

## 🧪 Testing

### Test Script Disponible

Archivo: `supabase/test-edge-functions.sh`

**Ejecutar**:
```bash
cd supabase
./test-edge-functions.sh
```

**Tests incluidos**:
1. ✅ get-subscription-status (sin auth)
2. ✅ handle-asaas-webhook (con payload test)
3. ✅ Verificar todas las 4 functions

---

## 📖 Documentación Creada

| Archivo | Descripción | Para qué sirve |
|---------|-------------|----------------|
| [CONFIGURAR_SECRETS.md](./CONFIGURAR_SECRETS.md) | Guía de configuración de secrets | Configurar environment variables |
| [test-edge-functions.sh](./test-edge-functions.sh) | Script de testing | Verificar deployment |
| [DEPLOYMENT_OPTIONS.md](./DEPLOYMENT_OPTIONS.md) | Opciones de deployment | Entender alternativas |
| [STATUS_DEPLOYMENT.md](./STATUS_DEPLOYMENT.md) | Este archivo | Status actual |

---

## 🎯 Checklist de Deployment

- [x] Edge Functions creadas
- [x] Edge Functions deployadas
- [x] Test script creado
- [ ] **Secrets configurados** ← ⚠️ **SIGUIENTE PASO**
- [ ] Webhook Asaas configurado
- [ ] Test end-to-end completo
- [ ] Integración Flutter (Fase 3)

---

## 📞 Comandos Útiles

### Ver logs de una function
```bash
# Ver logs en tiempo real (si proyecto está linkeado)
supabase functions logs get-subscription-status --follow

# O via Dashboard
# https://supa.rupies.com.br/project/_/logs/edge-functions
```

### Test rápido
```bash
# Sin auth (debe dar error de auth, no de config)
curl "https://supa.rupies.com.br/functions/v1/get-subscription-status"

# Con auth
curl "https://supa.rupies.com.br/functions/v1/get-subscription-status" \
  -H "Authorization: Bearer YOUR_JWT"
```

### Simular webhook Asaas
```bash
curl -X POST "https://supa.rupies.com.br/functions/v1/handle-asaas-webhook" \
  -H "Content-Type: application/json" \
  -d '{
    "event": "PAYMENT_RECEIVED",
    "payment": {
      "id": "pay_test",
      "status": "RECEIVED",
      "value": 99.90
    }
  }'
```

---

## 🎉 Resumen

### ✅ Completado
- Edge Functions implementadas (100%)
- Deployment exitoso (100%)
- Documentación completa (100%)
- Test script creado (100%)

### ⏳ En Progreso
- Configuración de secrets (0%)
- Testing end-to-end (0%)

### ⏭️ Pendiente
- Configurar webhook Asaas
- Integración Flutter (Fase 3)

---

## 📊 Progreso Total

```
Fase 1: Database Schema    ████████████████████ 100% ✅
Fase 2: Edge Functions     ███████████████████░  95% ⏳ (falta config)
Fase 3: Flutter UI         ░░░░░░░░░░░░░░░░░░░░   0% ⏭️
Fase 4: Testing            ░░░░░░░░░░░░░░░░░░░░   0% ⏭️
Fase 5: Production Deploy  ░░░░░░░░░░░░░░░░░░░░   0% ⏭️
```

**Tiempo estimado para completar Fase 2**: 10 minutos (solo configurar secrets)

---

**Última actualización**: 2025-01-02
**Próxima acción**: Configurar secrets → [CONFIGURAR_SECRETS.md](./CONFIGURAR_SECRETS.md)
