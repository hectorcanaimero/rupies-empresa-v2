# 🚀 Cómo Ejecutar las Migrations - Clube dos 100

## ✅ Verificación Completada

El script de verificación confirmó:

```
✅ Tabla subscriptions existe pero está VACÍA (0 registros)
✅ Es SEGURO dropar y recrear
✅ Conexión con Supabase OK
❌ Otras 4 tablas NO existen aún
```

---

## 📋 Opciones para Ejecutar

Tienes **3 opciones** para ejecutar las migrations:

---

### 🎯 OPCIÓN 1: Via Supabase Dashboard (RECOMENDADO ⭐)

**Mejor para**: Todos los usuarios, no requiere setup adicional

#### Pasos:

1. **Abrir SQL Editor**
   ```
   https://supa.rupies.com.br → SQL Editor
   ```

2. **Ejecutar Query de Limpieza**
   ```sql
   DROP TABLE IF EXISTS subscriptions CASCADE;
   ```
   ✅ Click en "Run"

3. **Ejecutar Migration 1**
   - Abrir archivo: `supabase/migrations/20251228_create_subscription_system.sql`
   - Copiar TODO el contenido
   - Pegar en SQL Editor
   - ✅ Click en "Run"

4. **Ejecutar Migration 2**
   - Abrir archivo: `supabase/migrations/20251228_create_subscription_functions.sql`
   - Copiar TODO el contenido
   - Pegar en SQL Editor
   - ✅ Click en "Run"

5. **Ejecutar Migration 3**
   - Abrir archivo: `supabase/migrations/20251228_create_subscription_views.sql`
   - Copiar TODO el contenido
   - Pegar en SQL Editor
   - ✅ Click en "Run"

6. **Verificar**
   ```sql
   SELECT table_name FROM information_schema.tables
   WHERE table_schema = 'public'
   AND table_name IN ('subscription_plans', 'subscriptions', 'payment_transactions', 'feature_flags', 'subscription_usage');
   ```
   **Debe retornar**: 5 tablas

---

### ⚡ OPCIÓN 2: Script Automatizado (SI TIENES PSQL)

**Mejor para**: Usuarios con acceso directo a PostgreSQL via `psql`

#### Pasos:

1. **Ejecutar Script**
   ```bash
   cd supabase
   ./ejecutar-migrations.sh
   ```

2. **Seguir las Instrucciones**
   - El script pedirá credenciales
   - Ejecutará todo automáticamente
   - Mostrará verificación al final

#### Requisitos:
- `psql` instalado
- Acceso directo al PostgreSQL del Supabase
- Credenciales de admin/postgres

---

### 🔧 OPCIÓN 3: Via Node.js con Supabase Client

**Mejor para**: Integración en scripts de deploy

<details>
<summary>Ver código (click para expandir)</summary>

```javascript
// ejecutar-migrations.mjs
import { createClient } from '@supabase/supabase-js'
import fs from 'fs/promises'

const supabase = createClient(
  'https://supa.rupies.com.br',
  'TU_SERVICE_ROLE_KEY' // ⚠️ Necesitas service_role key, NO anon key
)

async function runMigrations() {
  try {
    // 0. Dropar tabla antigua
    await supabase.rpc('exec_sql', {
      sql: 'DROP TABLE IF EXISTS subscriptions CASCADE;'
    })

    // 1. Migration 1
    const sql1 = await fs.readFile('migrations/20251228_create_subscription_system.sql', 'utf8')
    await supabase.rpc('exec_sql', { sql: sql1 })
    console.log('✅ Migration 1 completada')

    // 2. Migration 2
    const sql2 = await fs.readFile('migrations/20251228_create_subscription_functions.sql', 'utf8')
    await supabase.rpc('exec_sql', { sql: sql2 })
    console.log('✅ Migration 2 completada')

    // 3. Migration 3
    const sql3 = await fs.readFile('migrations/20251228_create_subscription_views.sql', 'utf8')
    await supabase.rpc('exec_sql', { sql: sql3 })
    console.log('✅ Migration 3 completada')

    console.log('\n🎉 Todas las migrations ejecutadas!')
  } catch (error) {
    console.error('❌ Error:', error)
  }
}

runMigrations()
```

**Nota**: Requiere `service_role` key (no la anon key)

</details>

---

## 🧪 Verificación Post-Ejecución

Después de ejecutar las migrations (cualquier método), verifica:

### Test Automatizado

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

### Queries Manuales

```sql
-- 1. Verificar tablas (debe retornar 5)
SELECT COUNT(*) FROM information_schema.tables
WHERE table_schema = 'public'
AND table_name IN ('subscription_plans', 'subscriptions', 'payment_transactions', 'feature_flags', 'subscription_usage');

-- 2. Verificar planos (debe retornar 3)
SELECT name, price_monthly, price_yearly FROM subscription_plans ORDER BY sort_order;

-- 3. Verificar feature flag (debe estar desabilitada)
SELECT flag_key, is_enabled FROM feature_flags WHERE flag_key = 'show_premium_features';

-- 4. Verificar tipo de user_id (debe ser TEXT)
SELECT column_name, data_type FROM information_schema.columns
WHERE table_name = 'subscriptions' AND column_name = 'user_id';

-- 5. Test de function
SELECT check_subscription_status('test-user-id');
```

---

## ❓ FAQ

### ¿Qué método debo usar?

- **Dashboard** → Más fácil, siempre funciona ⭐
- **Script bash** → Si tienes psql y quieres automatizar
- **Node.js** → Solo si tienes service_role key

### ¿Puedo ejecutar las migrations múltiples veces?

**Sí**, las migrations usan `CREATE TABLE IF NOT EXISTS` y `ON CONFLICT DO NOTHING`, son seguras para re-ejecutar.

### ¿Qué pasa si hay un error?

1. Lee el mensaje de error
2. Si es problema de permisos → Usa usuario postgres/admin
3. Si es tabla ya existe → Ejecuta `DROP TABLE ... CASCADE;` primero
4. Consulta: [RESOLVER_TABELA_EXISTENTE.md](./RESOLVER_TABELA_EXISTENTE.md)

### ¿Necesito ejecutar en orden?

**Sí**, SIEMPRE en este orden:
1. Dropar tabla antigua
2. Migration 1 (schema)
3. Migration 2 (functions)
4. Migration 3 (views)

Las functions dependen de las tablas, y las views dependen de las functions.

---

## 📞 Links Útiles

| Documento | Descripción |
|-----------|-------------|
| [EXECUTAR_MIGRATIONS.md](./EXECUTAR_MIGRATIONS.md) | Guía completa y detallada |
| [RESOLVER_TABELA_EXISTENTE.md](./RESOLVER_TABELA_EXISTENTE.md) | Troubleshooting tabla existente |
| [INDEX_CLUBE_100.md](./INDEX_CLUBE_100.md) | Índice de toda la documentación |

---

## 🎯 Próximos Pasos (Después de Ejecutar)

1. ✅ Verificar con `node test-connection.js`
2. ✅ Ejecutar queries de verificación
3. ✅ Confirmar que feature flag está desabilitada
4. 🚀 **Iniciar Fase 2**: Edge Functions (Integración Asaas)

---

**Creado**: 2025-01-02
**Status**: ✅ Migrations corregidas y listas para ejecutar
**Método recomendado**: Opción 1 (Supabase Dashboard)
