-- Script de verificação do sistema de notificações push
-- Execute no Supabase SQL Editor para verificar a configuração

-- ====================================
-- 1. VERIFICAR CONTRACTORS COM FCM TOKEN
-- ====================================
SELECT
  '1. Contractors com FCM Token' as verificacao,
  COUNT(*) as total,
  COUNT(CASE WHEN fcm_token IS NOT NULL AND fcm_token != '' THEN 1 END) as com_token,
  ROUND(
    100.0 * COUNT(CASE WHEN fcm_token IS NOT NULL AND fcm_token != '' THEN 1 END) / NULLIF(COUNT(*), 0),
    2
  ) as percentual_com_token
FROM users
WHERE isContractor = false
  AND status = true
  AND endRegister = true
  AND ban = false;

-- ====================================
-- 2. CONTRACTORS POR CATEGORIA
-- ====================================
SELECT
  '2. Contractors por Categoria' as verificacao,
  c.name as categoria,
  COUNT(DISTINCT us.userId) as total_contractors,
  COUNT(DISTINCT CASE
    WHEN u.fcm_token IS NOT NULL AND u.fcm_token != ''
    THEN us.userId
  END) as contractors_com_token
FROM users_skill us
INNER JOIN categories c ON c.id = us.categoryId
INNER JOIN users u ON u.id = us.userId
WHERE u.isContractor = false
  AND u.status = true
  AND u.endRegister = true
  AND u.ban = false
GROUP BY c.id, c.name
ORDER BY total_contractors DESC;

-- ====================================
-- 3. SERVIÇOS RECENTES (ÚLTIMOS 7 DIAS)
-- ====================================
SELECT
  '3. Serviços Recentes' as verificacao,
  s.id,
  s.name as servico,
  c.name as categoria,
  s.created_at,
  s.userId as empresa_id,
  (
    SELECT COUNT(DISTINCT us.userId)
    FROM users_skill us
    INNER JOIN users u ON u.id = us.userId
    WHERE us.categoryId = s.categoryId
      AND u.isContractor = false
      AND u.status = true
      AND u.fcm_token IS NOT NULL
  ) as contractors_notificados
FROM services s
LEFT JOIN categories c ON c.id = s.categoryId
WHERE s.created_at >= NOW() - INTERVAL '7 days'
ORDER BY s.created_at DESC
LIMIT 10;

-- ====================================
-- 4. ÍNDICES NECESSÁRIOS (VERIFICAR SE EXISTEM)
-- ====================================
SELECT
  '4. Índices Criados' as verificacao,
  schemaname,
  tablename,
  indexname
FROM pg_indexes
WHERE tablename IN ('users', 'users_skill', 'categories')
  AND indexname IN (
    'idx_users_skill_category',
    'idx_users_contractor_status',
    'idx_users_fcm_token'
  )
ORDER BY tablename, indexname;

-- ====================================
-- 5. EXEMPLO: SIMULAR CRIAÇÃO DE SERVIÇO
-- ====================================
-- Mostra quantos contractors receberiam notificação
-- para cada categoria

SELECT
  '5. Simulação por Categoria' as verificacao,
  c.id as categoria_id,
  c.name as categoria_nome,
  COUNT(DISTINCT u.id) as total_receberiam_push,
  ARRAY_AGG(DISTINCT u.display_name ORDER BY u.display_name)
    FILTER (WHERE u.display_name IS NOT NULL) as nomes_exemplo
FROM categories c
LEFT JOIN users_skill us ON us.categoryId = c.id
LEFT JOIN users u ON u.id = us.userId
  AND u.isContractor = false
  AND u.status = true
  AND u.endRegister = true
  AND u.ban = false
  AND u.fcm_token IS NOT NULL
  AND u.fcm_token != ''
WHERE c.status = true
GROUP BY c.id, c.name
ORDER BY total_receberiam_push DESC;

-- ====================================
-- 6. CONTRACTORS SEM TOKEN (ALERTA)
-- ====================================
SELECT
  '6. Contractors SEM Token (Precisam abrir o app)' as verificacao,
  u.id,
  u.display_name,
  u.email,
  u.created_at,
  ARRAY_AGG(DISTINCT c.name) as categorias
FROM users u
LEFT JOIN users_skill us ON us.userId = u.id
LEFT JOIN categories c ON c.id = us.categoryId
WHERE u.isContractor = false
  AND u.status = true
  AND u.endRegister = true
  AND u.ban = false
  AND (u.fcm_token IS NULL OR u.fcm_token = '')
GROUP BY u.id, u.display_name, u.email, u.created_at
ORDER BY u.created_at DESC
LIMIT 20;

-- ====================================
-- 7. ESTATÍSTICAS GERAIS
-- ====================================
SELECT
  '7. Estatísticas Gerais' as verificacao,
  (SELECT COUNT(*) FROM users WHERE isContractor = false) as total_contractors,
  (SELECT COUNT(*) FROM users WHERE isContractor = true) as total_empresas,
  (SELECT COUNT(*) FROM services) as total_servicos,
  (SELECT COUNT(*) FROM categories WHERE status = true) as categorias_ativas,
  (
    SELECT COUNT(*)
    FROM users
    WHERE isContractor = false
      AND fcm_token IS NOT NULL
      AND fcm_token != ''
  ) as contractors_com_push,
  (
    SELECT COUNT(*)
    FROM services
    WHERE created_at >= NOW() - INTERVAL '24 hours'
  ) as servicos_ultimas_24h;

-- ====================================
-- INSTRUÇÕES DE USO
-- ====================================
/*
COMO USAR ESTE SCRIPT:

1. Copiar todo este arquivo
2. Ir ao Supabase Dashboard → SQL Editor
3. Colar e executar
4. Analisar os resultados de cada verificação

RESULTADOS ESPERADOS:

✅ Verificação 1: Deve mostrar contractors com tokens FCM
✅ Verificação 2: Distribuição de contractors por categoria
✅ Verificação 3: Serviços criados recentemente
✅ Verificação 4: Índices devem aparecer se foram criados
✅ Verificação 5: Simulação de quantos receberiam push
✅ Verificação 6: Contractors que precisam configurar token
✅ Verificação 7: Overview geral do sistema

AÇÕES RECOMENDADAS:

Se Verificação 1 mostrar 0 contractors com token:
  → Os usuários precisam abrir o app e chamar setFCMToken()

Se Verificação 4 não mostrar os índices:
  → Executar o script de criação de índices (ver NOTIFICACOES_SERVICOS.md)

Se Verificação 6 mostrar muitos contractors:
  → Enviar comunicado pedindo para abrirem o app
*/
