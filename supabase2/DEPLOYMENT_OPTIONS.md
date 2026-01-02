# 🚀 Opciones de Deployment - Edge Functions

## 🔍 Situación Actual

Tu proyecto usa **Supabase self-hosted** en `https://supa.rupies.com.br`.

Las Edge Functions creadas están listas, pero el deployment depende de cómo está configurado tu Supabase.

---

## 📋 Opción 1: Supabase Cloud con Custom Domain (Recomendado)

Si `supa.rupies.com.br` es un **proxy/dominio custom** apuntando a Supabase Cloud, puedes deployar normalmente.

### Pasos:

1. **Encontrar el Project Reference ID**

```bash
# Buscar en el dashboard de Supabase
# URL del proyecto: https://supabase.com/dashboard/project/YOUR_PROJECT_REF
```

2. **Link del proyecto**

```bash
cd /Users/al3jandro/project/rupies/rupies-empresa
supabase link --project-ref YOUR_PROJECT_REF
```

3. **Deploy Edge Functions**

```bash
cd supabase
./deploy-functions.sh
```

4. **Configurar secrets**

```bash
supabase secrets set ASAAS_API_KEY=your_key_here
supabase secrets set ASAAS_ENVIRONMENT=sandbox
```

---

## 📋 Opción 2: Supabase Self-Hosted Completo (Docker)

Si es una instalación self-hosted completa, las Edge Functions necesitan Deno Deploy.

### Alternativa: Usar Firebase Cloud Functions

Como ya tienes **Firebase** configurado en el proyecto (veo `firebase/functions/index.js`), puedes adaptar las Edge Functions a Firebase Cloud Functions.

### Pasos:

1. **Adaptar código TypeScript a Firebase**

Las Edge Functions ya están escritas, solo necesitas:
- Cambiar imports de Deno → Node.js
- Usar Firebase Admin SDK en lugar de Supabase service client
- Mantener la lógica de Asaas igual

2. **Estructura Firebase**

```
firebase/functions/
├── src/
│   ├── asaas/
│   │   ├── create-subscription.ts
│   │   ├── handle-webhook.ts
│   │   ├── cancel-subscription.ts
│   │   └── get-status.ts
│   └── shared/
│       └── asaas-api.ts
```

3. **Deploy Firebase**

```bash
cd firebase/functions
npm run deploy
```

---

## 📋 Opción 3: API REST con Express (Alternativa Simple)

Si prefieres algo más simple, puedes crear una API REST con Express.js que corra en:
- Heroku
- Railway
- DigitalOcean
- AWS EC2

### Ventajas:
- Total control
- Fácil debugging
- Sin dependencias de plataforma

---

## 🎯 Recomendación

Necesito saber más sobre tu setup de Supabase:

### Pregunta 1: ¿Cómo accedes al Dashboard de Supabase?

**A)** Via `https://supabase.com/dashboard/project/...` (Supabase Cloud)
→ Usa **Opción 1**

**B)** Via `https://supa.rupies.com.br/project/...` (Self-hosted con UI)
→ Necesitas configurar Deno Deploy o usar **Opción 2/3**

**C)** No tienes UI, solo API REST
→ Usa **Opción 2** (Firebase) o **Opción 3** (Express)

### Pregunta 2: ¿Prefieres mantener todo en Supabase o usar Firebase?

El proyecto ya tiene **Firebase Functions** configurado (`firebase/functions/index.js`), entonces podría ser más rápido adaptar a Firebase.

---

## 💡 Mientras Decides: Testing Local

Puedes testar las Edge Functions localmente sin hacer deploy:

### Opción A: Deno Local

```bash
# Instalar Deno si no lo tienes
brew install deno

# Correr una function localmente
cd supabase/functions/get-subscription-status
deno run --allow-net --allow-env index.ts
```

### Opción B: Adaptar a Node.js y correr con Express

Puedo crear una versión Express.js de las functions para que pruebes localmente:

```bash
# Correr localmente
npm run dev

# Test
curl http://localhost:3000/api/subscription/status \
  -H "Authorization: Bearer YOUR_JWT"
```

---

## 🚀 Próximo Paso Recomendado

**Si quieres ir rápido**:
1. Usar **Firebase Cloud Functions** (ya tienes Firebase configurado)
2. Puedo adaptar las 4 Edge Functions a Firebase en ~30 minutos
3. Deploy: `firebase deploy --only functions`

**Si prefieres Supabase**:
1. Necesito saber el Project Reference ID
2. O confirmar si es self-hosted completo

**Dime cuál prefieres y continuamos!** 🚀

---

## 📖 Referencias

- [Supabase Edge Functions](https://supabase.com/docs/guides/functions)
- [Firebase Cloud Functions](https://firebase.google.com/docs/functions)
- [Deno Deploy](https://deno.com/deploy/docs)

---

**Creado**: 2025-01-02
**Status**: Esperando decisión sobre método de deployment
