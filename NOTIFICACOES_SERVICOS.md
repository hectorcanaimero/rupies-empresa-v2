# Notificações Push para Novos Serviços

Este documento descreve o sistema de notificações push automáticas que são enviadas para contractors quando um novo serviço é criado na plataforma Rupies Empresas.

## 📋 Visão Geral

Quando uma empresa cria um novo serviço, o sistema:

1. ✅ Detecta a criação do serviço via webhook do Supabase
2. ✅ Busca todos os contractors que têm a mesma categoria do serviço
3. ✅ Filtra apenas contractors ativos e com registro completo
4. ✅ Envia notificação push em português brasileiro para cada um

## 🏗️ Arquitetura

```
Supabase (Novo Serviço)
    ↓ (Webhook INSERT)
Firebase Cloud Function (onNewServiceCreated)
    ↓
Query Supabase (Buscar Contractors por Categoria)
    ↓
Firebase Cloud Messaging (Enviar Push)
    ↓
Dispositivos dos Contractors
```

## 📁 Arquivos Criados

### 1. Cloud Function Principal
**Arquivo**: `firebase/functions/supabase_webhooks.js`

**Funções**:
- `onNewServiceCreated` - Handler principal do webhook
- `getCategoryName` - Obtém o nome da categoria
- `findContractorsByCategory` - Busca contractors elegíveis
- `sendPushNotifications` - Envia notificações em lote

### 2. Exportação
**Arquivo**: `firebase/functions/index.js` (atualizado)

## 🔧 Configuração Necessária

### Passo 1: Configurar Supabase Service Key

A Cloud Function precisa da chave de serviço do Supabase para consultar dados.

**Opção A: Via Firebase CLI (Recomendado para Produção)**
```bash
firebase functions:config:set supabase.key="SUA_SUPABASE_SERVICE_KEY"
```

**Opção B: Via Variável de Ambiente (Para Testing Local)**
```bash
export SUPABASE_SERVICE_KEY="SUA_SUPABASE_SERVICE_KEY"
```

**Onde encontrar a Service Key:**
1. Ir ao [Dashboard do Supabase](https://supa.rupies.com.br)
2. Settings → API
3. Copiar `service_role` key (⚠️ NUNCA compartilhar esta chave!)

### Passo 2: Deploy da Cloud Function

```bash
cd firebase/functions

# Instalar dependências
npm install

# Fazer deploy
firebase deploy --only functions:onNewServiceCreated
```

**Após o deploy**, você receberá uma URL como:
```
https://southamerica-east1-rupies-brasil.cloudfunctions.net/onNewServiceCreated
```

### Passo 3: Configurar Webhook no Supabase

1. Ir ao **Dashboard do Supabase** → **Database** → **Webhooks**
2. Clicar em **Create a new webhook**
3. Configurar:
   - **Name**: `notify-contractors-new-service`
   - **Table**: `services`
   - **Events**: ✅ `INSERT` (marcar apenas INSERT)
   - **Type**: `HTTP Request`
   - **Method**: `POST`
   - **URL**: `https://YOUR-REGION-rupies-brasil.cloudfunctions.net/onNewServiceCreated`
   - **HTTP Headers**:
     ```
     Content-Type: application/json
     ```

4. Clicar em **Confirm**

### Passo 4: Verificar Índices na Base de Dados

Para performance otimizada, criar estes índices no Supabase:

```sql
-- Índice em users_skill.categoryId
CREATE INDEX IF NOT EXISTS idx_users_skill_category
ON users_skill(categoryId);

-- Índice em users.isContractor
CREATE INDEX IF NOT EXISTS idx_users_contractor_status
ON users(isContractor, status, endRegister)
WHERE isContractor = false;

-- Índice em users.fcm_token
CREATE INDEX IF NOT EXISTS idx_users_fcm_token
ON users(fcm_token)
WHERE fcm_token IS NOT NULL;
```

## 📊 Critérios de Filtragem

A função busca contractors que atendam **TODOS** estes critérios:

| Campo | Valor | Descrição |
|-------|-------|-----------|
| `isContractor` | `false` | É um contractor (não empresa) |
| `status` | `true` | Conta ativa |
| `endRegister` | `true` | Cadastro completo |
| `ban` | `false` | Não está banido |
| `fcm_token` | `NOT NULL` | Tem token FCM configurado |
| Categoria | Match | Tem a categoria do serviço em `users_skill` |

## 💬 Formato da Notificação

### Título (em Português)
```
🔔 Nova Oportunidade: [Nome da Categoria]
```

### Corpo
**Com preço:**
```
[Nome do Serviço] - R$ [Preço]. Toque para ver detalhes!
```

**Sem preço:**
```
[Nome do Serviço]. Toque para ver detalhes!
```

### Dados Extras (Data Payload)
```json
{
  "type": "new_service",
  "serviceId": "uuid-do-servico",
  "categoryName": "Nome da Categoria",
  "click_action": "FLUTTER_NOTIFICATION_CLICK"
}
```

## 🧪 Como Testar

### 1. Teste Local (Emulator)

```bash
cd firebase/functions

# Iniciar emulador
npm run serve

# A URL será algo como:
# http://localhost:5001/rupies-brasil/us-central1/onNewServiceCreated
```

**Enviar teste com cURL:**
```bash
curl -X POST http://localhost:5001/rupies-brasil/us-central1/onNewServiceCreated \
  -H "Content-Type: application/json" \
  -d '{
    "type": "INSERT",
    "record": {
      "id": "test-service-id",
      "name": "Serviço de Teste",
      "categoryId": "categoria-id-valida",
      "price": 150.00,
      "description": "Descrição do teste"
    }
  }'
```

### 2. Teste em Produção

**Criar um serviço real no Supabase:**

```sql
INSERT INTO services (
  "userId",
  "categoryId",
  name,
  description,
  price,
  status
) VALUES (
  'seu-user-id',
  'id-de-categoria-valida',
  'Serviço de Teste Push',
  'Teste de notificação push',
  100.00,
  true
);
```

O webhook dispara automaticamente!

### 3. Verificar Logs

**No Firebase Console:**
```bash
firebase functions:log --only onNewServiceCreated
```

**Ou via Firebase Console:**
1. Ir ao Firebase Console
2. Functions → Logs
3. Filtrar por `onNewServiceCreated`

### 4. Verificar no App

Para testar a recepção no app:

1. Garantir que você chamou `setFCMToken()` no app
2. Verificar que `FFAppState().fcmToken` não está vazio
3. Ter um usuário contractor com:
   - `isContractor = false`
   - Categoria registrada em `users_skill`
   - `fcm_token` salvo na base de dados

## 📈 Monitoramento

### Métricas Importantes

A função retorna estatísticas em cada execução:

```json
{
  "success": true,
  "message": "Notificações enviadas com éxito",
  "notificationsSent": 45,
  "contractorsFound": 50,
  "contractorsWithToken": 48
}
```

**Onde:**
- `contractorsFound`: Total de contractors com a categoria
- `contractorsWithToken`: Contractors que têm FCM token
- `notificationsSent`: Notificações enviadas com sucesso

### Logs Esperados

```
🔔 Webhook recebido - Novo servicio criado
📋 Servicio: Instalação de Ar Condicionado
🏷️ Categoría ID: abc-123
📂 Nome de categoría: Refrigeração
🔍 User IDs com a categoria: user1, user2, user3
👷 Contractors encontrados: 25
📱 Contractors com FCM token: 23
✅ Notificações enviadas: 22/23
```

## 🚨 Troubleshooting

### Webhook não dispara

1. **Verificar URL do webhook** no Supabase
2. **Verificar eventos** - Deve estar marcado `INSERT`
3. **Testar manualmente** com cURL
4. **Ver logs do Supabase**: Database → Webhooks → Ver logs

### Nenhuma notificação enviada

Possíveis causas:

1. **Serviço sem categoryId**
   ```
   ⚠️ Servicio sin categoría, no se envían notificaciones
   ```

2. **Nenhum contractor com essa categoria**
   ```
   ℹ️ No hay contractors disponibles para esta categoría
   ```

3. **Contractors sem FCM token**
   ```
   ℹ️ Ningún contractor tiene FCM token configurado
   ```

**Solução**: Verificar dados no Supabase:

```sql
-- Verificar contractors de uma categoria
SELECT u.id, u.display_name, u.fcm_token, u.isContractor
FROM users u
INNER JOIN users_skill us ON us.userId = u.id
WHERE us.categoryId = 'SEU-CATEGORY-ID'
  AND u.isContractor = false
  AND u.status = true;
```

### Erro de autenticação com Supabase

```
❌ Error buscando contractors: Request failed with status code 401
```

**Solução**: Verificar que a `SUPABASE_SERVICE_KEY` está configurada:

```bash
# Ver configuração atual
firebase functions:config:get

# Reconfigurar
firebase functions:config:set supabase.key="SUA-SERVICE-KEY"

# Re-deploy
firebase deploy --only functions:onNewServiceCreated
```

### Tokens inválidos

Alguns tokens podem falhar (usuário desinstalou app, etc.):

```
❌ Tokens fallidos: 3
```

**Solução Futura**: Implementar limpeza automática de tokens inválidos.

## 🔐 Segurança

### Boas Práticas Implementadas

✅ **Service Key protegida** - Nunca exposta no código
✅ **CORS configurado** - Aceita apenas requisições válidas
✅ **Validação de payload** - Verifica estrutura do webhook
✅ **Limite de lote** - Máximo 500 tokens por envio (limite FCM)
✅ **Error handling** - Não quebra em caso de falhas parciais

### Recomendações Adicionais

1. **Webhook Authentication**: Adicionar header secreto no webhook
2. **Rate Limiting**: Implementar limite de notificações por usuário
3. **Token Cleanup**: Remover tokens inválidos da base de dados
4. **Analytics**: Registrar estatísticas de abertura de notificações

## 📚 Próximos Passos

- [ ] Implementar deep linking para abrir serviço específico
- [ ] Adicionar preferências de notificação por usuário
- [ ] Criar dashboard de métricas de notificações
- [ ] Implementar notificações agendadas (lembretes)
- [ ] Adicionar A/B testing de mensagens
- [ ] Implementar notificações ricas (imagens, ações)

## 🎯 Exemplos de Uso

### Exemplo 1: Serviço de Encanamento

**Serviço criado:**
```json
{
  "name": "Conserto de Vazamento",
  "categoryId": "cat-encanamento",
  "price": 180.00
}
```

**Notificação enviada:**
```
🔔 Nova Oportunidade: Encanamento
Conserto de Vazamento - R$ 180.00. Toque para ver detalhes!
```

### Exemplo 2: Serviço de Limpeza

**Serviço criado:**
```json
{
  "name": "Limpeza Pós-Obra",
  "categoryId": "cat-limpeza",
  "price": null
}
```

**Notificação enviada:**
```
🔔 Nova Oportunidade: Limpeza
Limpeza Pós-Obra. Toque para ver detalhes!
```

---

**Desenvolvido por**: Ale - Flutter Developer
**Data**: 2025-12-28
**Versão**: 1.0
