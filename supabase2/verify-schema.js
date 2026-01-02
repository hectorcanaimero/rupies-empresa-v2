#!/usr/bin/env node

/**
 * Script de Verificación - Schema de tabla subscriptions
 * Verifica el schema actual antes de ejecutar migrations
 */

const SUPABASE_URL = 'https://supa.rupies.com.br';
const SUPABASE_ANON_KEY = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzdXBhYmFzZSIsImlhdCI6MTc0NzE2NTIwMCwiZXhwIjo0OTAyODM4ODAwLCJyb2xlIjoiYW5vbiJ9.PgTCx_EMA0DQrCWi84Mifi7HmWK8_DUFIsnQByq2cQY';

async function verifySchema() {
  console.log('🔍 Verificando schema de la tabla subscriptions existente...\n');

  try {
    // 1. Verificar si la tabla existe y tiene datos
    console.log('1️⃣ Verificando si hay datos en subscriptions...');
    const countResponse = await fetch(`${SUPABASE_URL}/rest/v1/subscriptions?select=count`, {
      headers: {
        'apikey': SUPABASE_ANON_KEY,
        'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
        'Prefer': 'count=exact'
      }
    });

    if (!countResponse.ok) {
      console.log('❌ Error al consultar tabla:', countResponse.status, countResponse.statusText);
      return;
    }

    const countHeader = countResponse.headers.get('content-range');
    const totalRecords = countHeader ? parseInt(countHeader.split('/')[1]) : 0;

    console.log(`   Total de registros: ${totalRecords}`);

    if (totalRecords === 0) {
      console.log('   ✅ Tabla VACÍA - Seguro dropar y recrear\n');
    } else {
      console.log('   ⚠️  Tabla tiene DATOS - Precaución al dropar\n');
    }

    // 2. Obtener algunos registros de ejemplo (si existen)
    if (totalRecords > 0) {
      console.log('2️⃣ Muestra de registros existentes (primeros 3):');
      const dataResponse = await fetch(`${SUPABASE_URL}/rest/v1/subscriptions?limit=3`, {
        headers: {
          'apikey': SUPABASE_ANON_KEY,
          'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
          'Content-Type': 'application/json'
        }
      });

      if (dataResponse.ok) {
        const data = await dataResponse.json();
        console.log(JSON.stringify(data, null, 2));
      }
      console.log('');
    }

    // 3. Intentar consultar la estructura (limitado por REST API)
    console.log('3️⃣ Intentando obtener estructura de columnas...');
    const sampleResponse = await fetch(`${SUPABASE_URL}/rest/v1/subscriptions?limit=1`, {
      headers: {
        'apikey': SUPABASE_ANON_KEY,
        'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
        'Content-Type': 'application/json'
      }
    });

    if (sampleResponse.ok) {
      const sample = await sampleResponse.json();
      if (sample.length > 0) {
        console.log('   Columnas detectadas en el primer registro:');
        Object.keys(sample[0]).forEach(key => {
          console.log(`   - ${key}: ${typeof sample[0][key]} = ${sample[0][key]}`);
        });
      } else {
        console.log('   ℹ️  Tabla vacía, no se puede inferir estructura desde REST API');
      }
    }
    console.log('');

    // 4. Recomendaciones
    console.log('━'.repeat(60));
    console.log('📋 RECOMENDACIONES:\n');

    if (totalRecords === 0) {
      console.log('✅ La tabla está VACÍA');
      console.log('   Puedes droparla sin riesgo:\n');
      console.log('   DROP TABLE IF EXISTS subscriptions CASCADE;\n');
      console.log('   Luego ejecuta las migrations normalmente.');
    } else {
      console.log('⚠️  La tabla tiene DATOS');
      console.log('   Opciones:\n');
      console.log('   A) Hacer BACKUP antes de dropar:');
      console.log('      CREATE TABLE subscriptions_backup AS SELECT * FROM subscriptions;\n');
      console.log('   B) Exportar a CSV desde Supabase Dashboard\n');
      console.log('   C) Si son datos de TEST, dropar directamente:');
      console.log('      DROP TABLE IF EXISTS subscriptions CASCADE;\n');
    }

    console.log('━'.repeat(60));
    console.log('\n📖 Para ver el schema completo (columnas, tipos, constraints):');
    console.log('   Ejecuta manualmente en SQL Editor:');
    console.log('   supabase/check-existing-schema.sql\n');

    console.log('📖 Guía completa de resolución:');
    console.log('   supabase/RESOLVER_TABELA_EXISTENTE.md\n');

    // 5. Test de otras tablas que deberían existir
    console.log('━'.repeat(60));
    console.log('4️⃣ Verificando otras tablas del sistema:\n');

    const otherTables = [
      'subscription_plans',
      'payment_transactions',
      'feature_flags',
      'subscription_usage'
    ];

    for (const table of otherTables) {
      const response = await fetch(`${SUPABASE_URL}/rest/v1/${table}?limit=0`, {
        headers: {
          'apikey': SUPABASE_ANON_KEY,
          'Authorization': `Bearer ${SUPABASE_ANON_KEY}`
        }
      });

      console.log(`   ${response.ok ? '✅' : '❌'} ${table}`);
    }

    console.log('\n━'.repeat(60));
    console.log('\n🎯 PRÓXIMO PASO:\n');

    if (totalRecords === 0) {
      console.log('1. Ejecuta en SQL Editor:');
      console.log('   DROP TABLE IF EXISTS subscriptions CASCADE;\n');
      console.log('2. Sigue la guía:');
      console.log('   supabase/EXECUTAR_MIGRATIONS.md\n');
    } else {
      console.log('1. Revisa los datos existentes');
      console.log('2. Decide si hacer backup o dropar');
      console.log('3. Ejecuta el script de verificación completa:');
      console.log('   supabase/check-existing-schema.sql\n');
      console.log('4. Sigue la guía:');
      console.log('   supabase/RESOLVER_TABELA_EXISTENTE.md\n');
    }

  } catch (error) {
    console.error('❌ Error durante verificación:', error.message);
    console.log('\n💡 Nota: Algunas queries requieren acceso directo a PostgreSQL.');
    console.log('   Para ver el schema completo, ejecuta en SQL Editor:');
    console.log('   supabase/check-existing-schema.sql\n');
  }
}

// Ejecutar verificación
verifySchema();
