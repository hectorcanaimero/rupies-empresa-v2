-- ═══════════════════════════════════════════════════════════════
-- SCRIPT COMPLETO: Clube dos 100 - Sistema de Assinaturas
-- ═══════════════════════════════════════════════════════════════
--
-- Este script executa TODAS as migrations em sequência:
-- 1. Remove tabela subscriptions antiga (vazia)
-- 2. Cria schema completo do sistema de assinaturas
-- 3. Cria functions PostgreSQL
-- 4. Cria views otimizadas
--
-- IMPORTANTE: Execute este arquivo COMPLETO de uma vez no SQL Editor
--
-- ═══════════════════════════════════════════════════════════════

-- ┌─────────────────────────────────────────────────────────────┐
-- │ PASSO 0: Limpeza (Dropar tabela antiga)                     │
-- └─────────────────────────────────────────────────────────────┘

DROP TABLE IF EXISTS subscriptions CASCADE;

-- ┌─────────────────────────────────────────────────────────────┐
-- │ PASSO 1: Criar Schema (Tabelas, RLS, Dados Iniciais)       │
-- └─────────────────────────────────────────────────────────────┘

