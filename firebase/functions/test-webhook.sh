#!/bin/bash

# Script para testar o webhook de novo serviço
# Uso: ./test-webhook.sh [local|prod]

MODE=${1:-local}

if [ "$MODE" = "local" ]; then
  # URL do emulador local
  URL="http://localhost:5001/rupies-brasil/us-central1/onNewServiceCreated"
  echo "🧪 Testando função LOCAL no emulador..."
elif [ "$MODE" = "prod" ]; then
  # URL de produção (ajustar região conforme necessário)
  URL="https://southamerica-east1-rupies-brasil.cloudfunctions.net/onNewServiceCreated"
  echo "🚀 Testando função em PRODUÇÃO..."
else
  echo "❌ Modo inválido. Use: local ou prod"
  exit 1
fi

echo "📡 URL: $URL"
echo ""

# Payload de teste simulando webhook do Supabase
PAYLOAD='{
  "type": "INSERT",
  "table": "services",
  "schema": "public",
  "record": {
    "id": "test-service-123",
    "name": "Instalação de Ar Condicionado",
    "description": "Preciso instalar um ar condicionado split 12000 BTUs",
    "categoryId": "SUBSTITUA-PELO-ID-REAL-DA-CATEGORIA",
    "price": 250.00,
    "userId": "user-empresa-123",
    "status": true,
    "created_at": "2025-12-28T10:00:00Z"
  },
  "old_record": null
}'

echo "📦 Payload:"
echo "$PAYLOAD" | jq .
echo ""

echo "🚀 Enviando requisição..."
echo ""

# Enviar requisição
RESPONSE=$(curl -X POST "$URL" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD" \
  -w "\n%{http_code}" \
  -s)

# Separar body e status code
HTTP_BODY=$(echo "$RESPONSE" | head -n -1)
HTTP_STATUS=$(echo "$RESPONSE" | tail -n 1)

echo "📥 Status Code: $HTTP_STATUS"
echo ""
echo "📄 Resposta:"
echo "$HTTP_BODY" | jq .
echo ""

if [ "$HTTP_STATUS" = "200" ]; then
  echo "✅ Teste concluído com SUCESSO!"
else
  echo "❌ Teste FALHOU com status $HTTP_STATUS"
  exit 1
fi
