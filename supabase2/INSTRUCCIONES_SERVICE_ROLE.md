# 🔐 Configurar Service Role Key

## 📋 Pasos para Ejecutar Migrations Automáticamente

### 1️⃣  Obtener el Service Role Key

1. Abre tu Supabase Dashboard:
   ```
   https://supa.rupies.com.br/project/_/settings/api
   ```

2. Busca la sección **"Project API keys"**

3. Copia el **"service_role"** key (es el key secreto, MUY LARGO)
   - ⚠️  NO copies el "anon" key
   - ⚠️  NO copies el "public" key
   - ✅ Copia el **"service_role" (secret)**

### 2️⃣  Pegar el Key en .env.local

1. Abre el archivo:
   ```
   supabase/.env.local
   ```

2. Busca la línea:
   ```
   SUPABASE_SERVICE_ROLE_KEY=PEGA_TU_SERVICE_ROLE_KEY_AQUI
   ```

3. Reemplaza `PEGA_TU_SERVICE_ROLE_KEY_AQUI` con tu key:
   ```
   SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc...TU_KEY_COMPLETO_AQUI
   ```

4. Guarda el archivo

### 3️⃣  Ejecutar las Migrations

```bash
cd supabase
npm run migrate
```

O directamente:

```bash
cd supabase
node ejecutar-con-service-role.js
```

### 4️⃣  Verificar Resultado

```bash
npm run test
```

O:

```bash
node test-connection.js
```

**Deberías ver**:
```
✅ subscription_plans
✅ subscriptions
✅ payment_transactions
✅ feature_flags
✅ subscription_usage

🎉 Migrations já foram executadas!
```

---

## ⚠️  Seguridad Importante

### El service_role key es PELIGROSO

Este key:
- ✅ Bypasa ALL RLS policies
- ✅ Puede leer/escribir TODO en el database
- ✅ Puede crear/dropar tablas
- ✅ Tiene permisos de ADMIN completo

### Protección

1. **NUNCA** lo commitees a Git
   - ✅ Ya está en `.gitignore`
   - ✅ Solo guárdalo en `.env.local`

2. **NUNCA** lo uses en el cliente (Flutter app)
   - ❌ NO lo pongas en `lib/backend/supabase/supabase.dart`
   - ✅ Solo úsalo en scripts de backend/migrations

3. **NUNCA** lo expongas públicamente
   - ❌ NO lo pegues en issues de GitHub
   - ❌ NO lo compartas en Slack/Discord
   - ❌ NO lo incluyas en screenshots

### Archivo .gitignore

Ya está configurado para proteger `.env.local`:

```gitignore
# Environment variables with sensitive keys
.env
.env.local
.env.*.local
```

---

## 🔍 Verificar que .env.local NO está en Git

```bash
# Esto NO debe mostrar .env.local
git status

# Si aparece .env.local, agrégalo al gitignore:
echo ".env.local" >> .gitignore
git add .gitignore
git commit -m "Add .env.local to gitignore"
```

---

## 🚨 Troubleshooting

### Error: "SUPABASE_SERVICE_ROLE_KEY no configurado"

**Causa**: No pegaste el key en `.env.local`

**Solución**:
1. Verifica que abriste `.env.local` (NO `.env`)
2. Verifica que pegaste el key completo (empieza con `eyJ...`)
3. Verifica que NO tiene espacios al inicio/final
4. Guarda el archivo

### Error: "exec_sql not found" o HTTP 404

**Causa**: El endpoint `exec_sql` no está disponible en tu Supabase

**Solución**: Usar método alternativo (Dashboard o psql)

Ver: [COMO_EJECUTAR.md](./COMO_EJECUTAR.md)

### Error: "Invalid JWT"

**Causa**: El service_role key está incorrecto o incompleto

**Solución**:
1. Vuelve al Dashboard
2. Copia de nuevo el **service_role** key COMPLETO
3. Pégalo en `.env.local`
4. Asegúrate de que no tenga saltos de línea

---

## ✅ Checklist

Antes de ejecutar `npm run migrate`, verifica:

- [ ] Obtuve el service_role key del Dashboard
- [ ] Lo pegué en `supabase/.env.local`
- [ ] El key empieza con `eyJ...`
- [ ] Guardé el archivo `.env.local`
- [ ] Verifiqué que `.env.local` está en `.gitignore`
- [ ] Ejecuté `npm install` en la carpeta supabase

---

## 📖 Método Alternativo (Sin Service Role Key)

Si no quieres usar el service_role key o si el método automatizado no funciona:

### Opción: Supabase Dashboard (Manual)

1. Ir a: https://supa.rupies.com.br
2. SQL Editor → New Query
3. Ejecutar:
   ```sql
   DROP TABLE IF EXISTS subscriptions CASCADE;
   ```
4. Ejecutar migration 1:
   - Abrir: `supabase/migrations/20251228_create_subscription_system.sql`
   - Copiar TODO el contenido
   - Pegar en SQL Editor
   - Click "Run"
5. Ejecutar migration 2 (functions)
6. Ejecutar migration 3 (views)

Ver guía completa: [COMO_EJECUTAR.md](./COMO_EJECUTAR.md)

---

**Creado**: 2025-01-02
**Para**: Ejecución automatizada de migrations
**Seguridad**: ⚠️  CRÍTICO - Proteger service_role key
