# 🚀 EJECUTAR AHORA - Guía Visual Rápida

## ✅ Archivo Listo Para Copiar/Pegar

📂 **MIGRATION_COMPLETA.sql** (44KB)

Este archivo contiene:
- ✅ DROP de tabla antigua
- ✅ Migration 1: Schema (5 tablas + RLS)
- ✅ Migration 2: Functions (8 functions)
- ✅ Migration 3: Views (7 views)
- ✅ Query de verificación automática

---

## 📋 Pasos (40 segundos total)

### 1️⃣  Abrir archivo (10 seg)

```
Archivo: supabase/MIGRATION_COMPLETA.sql
```

**Acción**: Abre este archivo en tu editor

---

### 2️⃣  Copiar TODO (5 seg)

**Mac**: `Cmd + A` → `Cmd + C`
**Windows/Linux**: `Ctrl + A` → `Ctrl + C`

---

### 3️⃣  Abrir Dashboard (5 seg)

```
URL: https://supa.rupies.com.br
```

**Acción**:
1. Abre el link en tu navegador
2. Login si es necesario

---

### 4️⃣  Ir a SQL Editor (5 seg)

**Navegación**:
```
Menú lateral → SQL Editor → New Query
```

**O click en**:
- "SQL Editor" (icono de database)
- Botón "+ New query"

---

### 5️⃣  Pegar y Ejecutar (15 seg)

**Acción**:
1. Click en el área de texto del editor
2. Pegar: `Cmd + V` (Mac) o `Ctrl + V` (Win/Linux)
3. Click botón **"Run"** (▶️) en la esquina superior derecha
4. **Espera...** (10-30 segundos)

---

### 6️⃣  Verificar Resultado (5 seg)

**Deberías ver en los resultados**:

```sql
status: "🎉 MIGRATION COMPLETADA!"
```

**Y una tabla con**:
```
✅ feature_flags
✅ payment_transactions
✅ subscription_plans
✅ subscription_usage
✅ subscriptions
```

---

## ✅ Post-Ejecución

### Verificar con script

```bash
cd supabase
node test-connection.js
```

**Resultado esperado**:
```
✅ subscription_plans
✅ subscriptions
✅ payment_transactions
✅ feature_flags
✅ subscription_usage

🎉 Migrations já foram executadas!
```

---

## 🎯 Queries de Verificación Manual

Si quieres verificar manualmente en SQL Editor:

### 1. Verificar tablas (debe retornar 5)

```sql
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public'
AND table_name IN (
  'subscription_plans',
  'subscriptions',
  'payment_transactions',
  'feature_flags',
  'subscription_usage'
)
ORDER BY table_name;
```

### 2. Verificar planos insertados (debe retornar 3)

```sql
SELECT name, price_monthly, price_yearly
FROM subscription_plans
ORDER BY sort_order;
```

**Esperado**:
| name | price_monthly | price_yearly |
|------|---------------|--------------|
| Grátis | 0.00 | 0.00 |
| Clube dos 100 - Mensal | 99.90 | NULL |
| Clube dos 100 - Anual | NULL | 959.04 |

### 3. Verificar feature flag

```sql
SELECT flag_key, is_enabled, description
FROM feature_flags;
```

**Esperado**:
```
flag_key: show_premium_features
is_enabled: false
description: Controla se features premium são visíveis...
```

### 4. Verificar user_id es TEXT (NO UUID)

```sql
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'subscriptions'
AND column_name = 'user_id';
```

**Esperado**:
```
column_name: user_id
data_type: text
```

### 5. Test de function

```sql
SELECT check_subscription_status('test-user-id');
```

**Esperado**: JSON con `has_active_subscription: false`

---

## 🚨 Si Algo Sale Mal

### Error: "duplicate key value violates unique constraint"

**Causa**: Ya ejecutaste las migrations antes

**Solución**:
```sql
-- Dropar TODO y empezar de nuevo
DROP TABLE IF EXISTS subscription_usage CASCADE;
DROP TABLE IF EXISTS payment_transactions CASCADE;
DROP TABLE IF EXISTS subscriptions CASCADE;
DROP TABLE IF EXISTS subscription_plans CASCADE;
DROP TABLE IF EXISTS feature_flags CASCADE;

-- Ahora ejecutar MIGRATION_COMPLETA.sql de nuevo
```

### Error: "permission denied"

**Causa**: No tienes permisos de admin

**Solución**:
- Verifica que estás loggeado como admin
- O usa el usuario `postgres` con password de superuser

### Error: "function already exists"

**Causa**: Las functions ya existen

**Solución**: Está OK, las migrations usan `CREATE OR REPLACE FUNCTION`

### El script no termina / se queda colgado

**Causa**: El SQL es muy largo y el navegador está procesando

**Solución**:
- Espera un poco más (hasta 60 segundos)
- Si no responde, refresh y ejecuta en 3 partes separadas:
  1. Solo la parte de DROP + tablas
  2. Solo la parte de functions
  3. Solo la parte de views

---

## 📞 Después de Ejecutar

### 1. Ejecuta el test

```bash
cd supabase
npm run test
```

### 2. Avísame el resultado

Dime:
- ✅ "Funcionó! Las 5 tablas se crearon"
- ❌ "Hubo error: [copia el error aquí]"

### 3. Siguiente paso

Si todo OK → **Fase 2: Edge Functions Asaas** 🚀

---

## 🎬 Video Tutorial (Próximamente)

Si prefieres un video mostrando el proceso, avísame y lo grabo.

---

## 📱 Screenshot de Referencia

**SQL Editor debería verse así**:

```
┌─────────────────────────────────────────────────────────┐
│ SQL Editor                                   [▶️ Run]   │
├─────────────────────────────────────────────────────────┤
│                                                         │
│ -- MIGRATION COMPLETA - Sistema Clube dos 100          │
│ ...                                                     │
│ [Aquí pegas el SQL completo]                           │
│ ...                                                     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

**Resultados deberían verse así**:

```
┌─────────────────────────────────────────────────────────┐
│ Results                                                 │
├─────────────────────────────────────────────────────────┤
│ status: "🎉 MIGRATION COMPLETADA!"                     │
│                                                         │
│ table_name                                              │
│ ─────────────────                                       │
│ feature_flags                                           │
│ payment_transactions                                    │
│ subscription_plans                                      │
│ subscription_usage                                      │
│ subscriptions                                           │
└─────────────────────────────────────────────────────────┘
```

---

**¡Adelante! Todo está listo. Tiempo estimado: 40 segundos.** ⏱️

**Archivo a usar**: `supabase/MIGRATION_COMPLETA.sql`

**Dashboard**: https://supa.rupies.com.br

🚀 ¡Vamos!
