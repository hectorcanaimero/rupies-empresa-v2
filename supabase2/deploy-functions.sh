#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════
# Deploy Script - Edge Functions Clube dos 100
# ═══════════════════════════════════════════════════════════════════════════
#
# Este script faz deploy de todas as Edge Functions de uma vez
#
# Uso:
#   ./deploy-functions.sh
#
# ═══════════════════════════════════════════════════════════════════════════

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions a deployar
functions=(
  "create-asaas-subscription"
  "handle-asaas-webhook"
  "cancel-subscription"
  "get-subscription-status"
)

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Deploy Edge Functions - Clube dos 100                       ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Verificar se Supabase CLI está instalado
if ! command -v supabase &> /dev/null; then
    echo -e "${RED}❌ Erro: Supabase CLI não está instalado${NC}"
    echo -e "${YELLOW}Instale com: npm install -g supabase${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Supabase CLI encontrado${NC}"
echo ""

# Verificar se está linkado ao projeto
if ! supabase projects list &> /dev/null; then
    echo -e "${RED}❌ Erro: Não está autenticado no Supabase${NC}"
    echo -e "${YELLOW}Execute: supabase login${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Autenticado no Supabase${NC}"
echo ""

# Perguntar confirmação
echo -e "${YELLOW}⚠️  Você está prestes a fazer deploy de ${#functions[@]} Edge Functions${NC}"
echo ""
echo "Functions a serem deployadas:"
for func in "${functions[@]}"; do
  echo "  - $func"
done
echo ""
read -p "Continuar? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Deploy cancelado pelo usuário${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Deploy de cada function
success_count=0
failed_count=0
failed_functions=()

for func in "${functions[@]}"; do
  echo ""
  echo -e "${BLUE}📦 Deployando: ${func}${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

  if supabase functions deploy "$func" --no-verify-jwt; then
    echo -e "${GREEN}✅ ${func} deployed com sucesso${NC}"
    ((success_count++))
  else
    echo -e "${RED}❌ Erro ao deployar ${func}${NC}"
    ((failed_count++))
    failed_functions+=("$func")
  fi
done

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}RESUMO DO DEPLOY${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}✅ Sucesso: ${success_count}${NC}"

if [ $failed_count -gt 0 ]; then
  echo -e "${RED}❌ Falhas: ${failed_count}${NC}"
  echo ""
  echo "Functions que falharam:"
  for func in "${failed_functions[@]}"; do
    echo -e "  ${RED}✗${NC} $func"
  done
  echo ""
  echo -e "${YELLOW}💡 Dica: Verifique os logs com:${NC}"
  echo -e "${YELLOW}   supabase functions logs <function-name>${NC}"
  exit 1
else
  echo ""
  echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║  ✅ TODAS AS EDGE FUNCTIONS FORAM DEPLOYADAS COM SUCESSO!       ║${NC}"
  echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  echo -e "${BLUE}📋 Próximos passos:${NC}"
  echo ""
  echo -e "${YELLOW}1. Configurar secrets:${NC}"
  echo "   supabase secrets set ASAAS_API_KEY=your_key_here"
  echo "   supabase secrets set ASAAS_ENVIRONMENT=sandbox"
  echo ""
  echo -e "${YELLOW}2. Verificar deploy:${NC}"
  echo "   supabase functions list"
  echo ""
  echo -e "${YELLOW}3. Configurar webhook no Asaas:${NC}"
  echo "   URL: https://supa.rupies.com.br/functions/v1/handle-asaas-webhook"
  echo ""
  echo -e "${YELLOW}4. Testar functions:${NC}"
  echo "   curl https://supa.rupies.com.br/functions/v1/get-subscription-status \\"
  echo "     -H \"Authorization: Bearer YOUR_JWT\""
  echo ""
  echo -e "${YELLOW}5. Ver logs:${NC}"
  echo "   supabase functions logs --all --follow"
  echo ""
fi
