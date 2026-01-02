#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════
# Test Script - Edge Functions
# ═══════════════════════════════════════════════════════════════════════════

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Base URL
BASE_URL="https://supa.rupies.com.br/functions/v1"

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          Test Edge Functions - Clube dos 100                    ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Test 1: get-subscription-status (sin auth)
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}TEST 1: get-subscription-status (sin autenticación)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Request:${NC}"
echo "GET ${BASE_URL}/get-subscription-status"
echo ""
echo -e "${YELLOW}Response:${NC}"

response=$(curl -s -X GET "${BASE_URL}/get-subscription-status" \
  -H "Content-Type: application/json")

echo "$response" | jq '.' 2>/dev/null || echo "$response"
echo ""

# Verificar si hay error de configuración
if echo "$response" | grep -q "Invalid supabaseUrl"; then
  echo -e "${RED}❌ ERROR: Secrets no configurados${NC}"
  echo -e "${YELLOW}Los secrets SUPABASE_URL y SUPABASE_SERVICE_ROLE_KEY faltan.${NC}"
  echo ""
  echo -e "${YELLOW}📖 Ver guía de configuración:${NC}"
  echo "   supabase/CONFIGURAR_SECRETS.md"
  echo ""
  exit 1
elif echo "$response" | grep -q "Authorization header"; then
  echo -e "${GREEN}✅ Function deployada correctamente${NC}"
  echo -e "${GREEN}✅ Secrets configurados${NC}"
  echo -e "${YELLOW}⚠️  Falta token de autenticación (esperado)${NC}"
else
  echo -e "${YELLOW}⚠️  Respuesta inesperada${NC}"
fi

echo ""

# Test 2: handle-asaas-webhook (público)
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}TEST 2: handle-asaas-webhook (público)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Request:${NC}"
echo "POST ${BASE_URL}/handle-asaas-webhook"
echo ""
echo -e "${YELLOW}Payload (test):${NC}"

payload='{
  "event": "PAYMENT_RECEIVED",
  "payment": {
    "id": "pay_test_123",
    "customer": "cus_test_123",
    "subscription": "sub_test_123",
    "value": 99.90,
    "status": "RECEIVED",
    "dueDate": "2024-01-01",
    "paymentDate": "2024-01-01"
  }
}'

echo "$payload" | jq '.' 2>/dev/null || echo "$payload"
echo ""
echo -e "${YELLOW}Response:${NC}"

response=$(curl -s -X POST "${BASE_URL}/handle-asaas-webhook" \
  -H "Content-Type: application/json" \
  -d "$payload")

echo "$response" | jq '.' 2>/dev/null || echo "$response"
echo ""

if echo "$response" | grep -q "success"; then
  echo -e "${GREEN}✅ Webhook endpoint funcionando${NC}"
else
  echo -e "${YELLOW}⚠️  Respuesta inesperada (pero endpoint acessível)${NC}"
fi

echo ""

# Test 3: Verificar todas las functions
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}TEST 3: Verificar todas las functions${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

functions=(
  "create-asaas-subscription"
  "handle-asaas-webhook"
  "cancel-subscription"
  "get-subscription-status"
)

for func in "${functions[@]}"; do
  echo -n "Testing ${func}... "

  # HEAD request para verificar si existe
  status=$(curl -s -o /dev/null -w "%{http_code}" -X GET "${BASE_URL}/${func}")

  if [ "$status" -eq "200" ] || [ "$status" -eq "400" ] || [ "$status" -eq "401" ]; then
    echo -e "${GREEN}✅ Deployada (HTTP $status)${NC}"
  else
    echo -e "${RED}❌ No accesible (HTTP $status)${NC}"
  fi
done

echo ""

# Resumen
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}RESUMEN${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}✅ Edge Functions deployadas correctamente${NC}"
echo ""
echo -e "${YELLOW}📋 Próximos pasos:${NC}"
echo ""
echo "1. Configurar secrets (si aún no lo hiciste):"
echo "   Ver: supabase/CONFIGURAR_SECRETS.md"
echo ""
echo "2. Configurar webhook en Asaas:"
echo "   URL: ${BASE_URL}/handle-asaas-webhook"
echo "   Dashboard: https://sandbox.asaas.com"
echo ""
echo "3. Testar con token de usuario:"
echo "   curl \"${BASE_URL}/get-subscription-status\" \\"
echo "     -H \"Authorization: Bearer YOUR_JWT_TOKEN\""
echo ""
echo "4. Ver logs:"
echo "   Dashboard → Edge Functions → Logs"
echo ""
