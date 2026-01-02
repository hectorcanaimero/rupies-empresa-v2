#!/usr/bin/env node

/**
 * Script de Teste - Conexão Supabase
 * Testa conexão e verifica estado do banco antes das migrations
 */

const SUPABASE_URL = 'https://supa.rupies.com.br';
const SUPABASE_ANON_KEY = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJzdXBhYmFzZSIsImlhdCI6MTc0NzE2NTIwMCwiZXhwIjo0OTAyODM4ODAwLCJyb2xlIjoiYW5vbiJ9.PgTCx_EMA0DQrCWi84Mifi7HmWK8_DUFIsnQByq2cQY';

async function testConnection() {
  console.log('🔍 Testando conexão com Supabase...\n');

  try {
    // Teste 1: Health check
    console.log('1️⃣ Health Check...');
    const healthResponse = await fetch(`${SUPABASE_URL}/rest/v1/`, {
      headers: {
        'apikey': SUPABASE_ANON_KEY,
        'Authorization': `Bearer ${SUPABASE_ANON_KEY}`
      }
    });

    if (healthResponse.ok) {
      console.log('✅ Conexão OK - Status:', healthResponse.status);
    } else {
      console.log('❌ Erro na conexão - Status:', healthResponse.status);
      return;
    }

    // Teste 2: Verificar tabela users
    console.log('\n2️⃣ Verificando tabela users...');
    const usersResponse = await fetch(`${SUPABASE_URL}/rest/v1/users?select=id&limit=1`, {
      headers: {
        'apikey': SUPABASE_ANON_KEY,
        'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
        'Content-Type': 'application/json'
      }
    });

    if (usersResponse.ok) {
      const users = await usersResponse.json();
      console.log('✅ Tabela users encontrada');
      console.log(`   Total de registros testados: ${users.length}`);
    } else {
      console.log('⚠️  Tabela users não encontrada ou sem acesso');
    }

    // Teste 3: Verificar se tabelas de subscription já existem
    console.log('\n3️⃣ Verificando tabelas de assinatura...');
    const tables = [
      'subscription_plans',
      'subscriptions',
      'payment_transactions',
      'feature_flags',
      'subscription_usage'
    ];

    const results = [];
    for (const table of tables) {
      const response = await fetch(`${SUPABASE_URL}/rest/v1/${table}?limit=0`, {
        headers: {
          'apikey': SUPABASE_ANON_KEY,
          'Authorization': `Bearer ${SUPABASE_ANON_KEY}`
        }
      });

      results.push({
        table,
        exists: response.ok,
        status: response.status
      });
    }

    console.log('\n📊 Resultado:');
    results.forEach(({ table, exists }) => {
      console.log(`   ${exists ? '✅' : '❌'} ${table}`);
    });

    const allExist = results.every(r => r.exists);

    if (allExist) {
      console.log('\n🎉 Migrations já foram executadas!');
      console.log('   Todas as tabelas de assinatura existem.');
    } else {
      console.log('\n⏳ Migrations ainda não foram executadas.');
      console.log('   Execute as migrations seguindo o guia: EXECUTAR_MIGRATIONS.md');
    }

    // Teste 4: Verificar tipo da coluna user_id (se subscriptions existir)
    const subsExists = results.find(r => r.table === 'subscriptions')?.exists;
    if (subsExists) {
      console.log('\n4️⃣ Verificando tipo da coluna user_id...');
      // Esta query requer acesso ao information_schema, que pode não estar disponível via REST API
      console.log('   (Verificação manual necessária via SQL Editor)');
    }

    console.log('\n✅ Teste de conexão concluído!\n');

  } catch (error) {
    console.error('❌ Erro durante teste:', error.message);
  }
}

// Executar teste
testConnection();
