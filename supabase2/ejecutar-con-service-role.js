#!/usr/bin/env node

/**
 * Ejecutar Migrations con Service Role Key
 *
 * Este script usa el service_role_key de Supabase para ejecutar
 * las migrations DDL (CREATE TABLE, CREATE FUNCTION, etc.)
 *
 * REQUISITOS:
 * - Archivo .env.local con SUPABASE_SERVICE_ROLE_KEY configurado
 */

const fs = require('fs').promises;
const path = require('path');

// Cargar variables de entorno
require('dotenv').config({ path: path.join(__dirname, '.env.local') });

const SUPABASE_URL = process.env.SUPABASE_URL || 'https://supa.rupies.com.br';
const SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

// Colores para output
const colors = {
  reset: '\x1b[0m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
};

function log(color, message) {
  console.log(`${colors[color]}${message}${colors.reset}`);
}

async function ejecutarSQL(sql, descripcion) {
  try {
    log('blue', `\n🔄 Ejecutando: ${descripcion}...`);

    // Usar la API de PostgREST para ejecutar SQL
    // Nota: Esto requiere un endpoint específico de Supabase que soporte SQL execution
    const response = await fetch(`${SUPABASE_URL}/rest/v1/rpc/exec_sql`, {
      method: 'POST',
      headers: {
        'apikey': SERVICE_ROLE_KEY,
        'Authorization': `Bearer ${SERVICE_ROLE_KEY}`,
        'Content-Type': 'application/json',
        'Prefer': 'return=representation'
      },
      body: JSON.stringify({ query: sql })
    });

    if (!response.ok) {
      // Si no existe exec_sql, intentar método alternativo
      const text = await response.text();
      throw new Error(`HTTP ${response.status}: ${text}`);
    }

    const result = await response.json();
    log('green', `✅ ${descripcion} - Completado`);
    return result;

  } catch (error) {
    log('red', `❌ Error en ${descripcion}:`);
    console.error(error.message);
    throw error;
  }
}

async function ejecutarMigrations() {
  log('blue', '╔══════════════════════════════════════════════════════════════════╗');
  log('blue', '║     Ejecutando Migrations - Clube dos 100 via Service Role      ║');
  log('blue', '╚══════════════════════════════════════════════════════════════════╝\n');

  // Verificar service_role_key
  if (!SERVICE_ROLE_KEY || SERVICE_ROLE_KEY === 'PEGA_TU_SERVICE_ROLE_KEY_AQUI') {
    log('red', '❌ ERROR: SUPABASE_SERVICE_ROLE_KEY no configurado');
    log('yellow', '\n📝 Pasos para configurar:');
    log('yellow', '1. Abre: https://supa.rupies.com.br/project/_/settings/api');
    log('yellow', '2. Copia el "service_role" key (secret)');
    log('yellow', '3. Pégalo en: supabase/.env.local');
    log('yellow', '   SUPABASE_SERVICE_ROLE_KEY=eyJhbGci...tu-key-aqui\n');
    process.exit(1);
  }

  log('green', '✅ Service Role Key encontrado');
  log('yellow', `📍 Supabase URL: ${SUPABASE_URL}\n`);

  // Definir migrations
  const migrations = [
    {
      file: 'migrations/20251228_create_subscription_system.sql',
      nombre: 'Schema del Sistema (Tablas, RLS, Datos)'
    },
    {
      file: 'migrations/20251228_create_subscription_functions.sql',
      nombre: 'Functions PostgreSQL'
    },
    {
      file: 'migrations/20251228_create_subscription_views.sql',
      nombre: 'Views Optimizadas'
    }
  ];

  log('blue', '━'.repeat(70));
  log('blue', 'PASO 0: Limpieza - Dropar tabla existente');
  log('blue', '━'.repeat(70));

  try {
    await ejecutarSQL(
      'DROP TABLE IF EXISTS subscriptions CASCADE;',
      'Dropar tabla subscriptions antigua'
    );
  } catch (error) {
    log('yellow', '⚠️  Nota: Tabla subscriptions puede no existir (OK)');
  }

  // Ejecutar cada migration
  for (let i = 0; i < migrations.length; i++) {
    const { file, nombre } = migrations[i];
    const filePath = path.join(__dirname, file);

    log('blue', '\n' + '━'.repeat(70));
    log('blue', `PASO ${i + 1}: ${nombre}`);
    log('blue', '━'.repeat(70));

    try {
      // Leer archivo SQL
      const sql = await fs.readFile(filePath, 'utf8');
      log('yellow', `📄 Leyendo: ${file}`);
      log('yellow', `   Tamaño: ${(sql.length / 1024).toFixed(2)} KB`);

      // Ejecutar SQL
      await ejecutarSQL(sql, nombre);

    } catch (error) {
      log('red', `\n❌ Error ejecutando migration ${i + 1}`);
      log('red', `   Archivo: ${file}`);
      log('red', `   Error: ${error.message}\n`);

      // Si es el método exec_sql que no existe, dar alternativa
      if (error.message.includes('exec_sql') || error.message.includes('404')) {
        log('yellow', '\n⚠️  LIMITACIÓN DETECTADA:');
        log('yellow', 'El endpoint exec_sql no está disponible en este Supabase.');
        log('yellow', '\nMétodo alternativo requerido:\n');
        log('blue', '1️⃣  MÉTODO DASHBOARD (Recomendado):');
        log('yellow', '   • Ir a: https://supa.rupies.com.br');
        log('yellow', '   • SQL Editor → New Query');
        log('yellow', '   • Copiar/pegar el contenido de cada migration');
        log('yellow', '   • Click "Run"\n');
        log('blue', '2️⃣  MÉTODO PSQL:');
        log('yellow', '   • ./ejecutar-migrations.sh\n');
        log('yellow', '📖 Ver guía completa: COMO_EJECUTAR.md\n');
      }

      process.exit(1);
    }
  }

  // Verificación final
  log('blue', '\n' + '━'.repeat(70));
  log('blue', 'VERIFICACIÓN FINAL');
  log('blue', '━'.repeat(70) + '\n');

  log('yellow', '🔍 Verificando tablas creadas...');
  log('yellow', 'Ejecuta: node test-connection.js\n');

  log('green', '╔══════════════════════════════════════════════════════════════════╗');
  log('green', '║              ✅ MIGRATIONS COMPLETADAS EXITOSAMENTE              ║');
  log('green', '╚══════════════════════════════════════════════════════════════════╝\n');

  log('yellow', '📋 Próximos pasos:');
  log('yellow', '1. Verificar: node test-connection.js');
  log('yellow', '2. Iniciar Fase 2: Edge Functions Asaas\n');
}

// Ejecutar
ejecutarMigrations().catch(error => {
  log('red', '\n❌ Error fatal:');
  console.error(error);
  process.exit(1);
});
