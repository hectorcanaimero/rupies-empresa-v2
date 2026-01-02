# 🧪 Teste do Sistema de Assinaturas - Clube dos 100

**Data**: 2025-01-02
**Versão**: 1.0
**Status**: ✅ Pronto para Teste

---

## 📋 Pré-requisitos

Antes de testar, verifique:

- ✅ **Database**: Migrations executadas (Fase 1)
- ✅ **Edge Functions**: 4 functions deployadas (Fase 2)
- ✅ **Custom Actions**: 4 actions criadas (Fase 3)
- ✅ **Pages**: 2 páginas criadas (Fase 3)
- ✅ **Navigation**: Rotas registradas (Fase 3)
- ⚠️ **Dados de Teste**: Planos cadastrados no database

### Verificar Planos no Database

```sql
-- Execute no Supabase SQL Editor
SELECT
  id,
  name,
  price_monthly,
  price_yearly,
  is_active,
  features
FROM subscription_plans
WHERE is_active = true
ORDER BY sort_order;
```

**Esperado**: 3 planos (Básico, Clube dos 100, Premium)

Se não houver planos, os seeds foram executados nas migrations.

---

## 🚀 Como Testar

### Método 1: Teste Manual via Flutter App

#### 1. Compilar e Executar o App

```bash
cd /Users/al3jandro/project/rupies/rupies-empresa

# Limpar cache
flutter clean

# Instalar dependências
flutter pub get

# Executar no emulador/device
flutter run
```

#### 2. Fazer Login

- Abra o app
- Faça login com um usuário válido
- Navegue até o menu principal

#### 3. Navegar para Subscription Plans

**Opção A: Via código temporário**

Adicionar botão temporário em qualquer página (ex: `home_page_widget.dart`):

```dart
ElevatedButton(
  onPressed: () {
    context.pushNamed('SubscriptionPlansPage');
  },
  child: Text('🎯 Testar Clube dos 100'),
)
```

**Opção B: Via deep link**

```bash
# Android
adb shell am start -a android.intent.action.VIEW \
  -d "rupiesempresa://rupiesempresa.com/subscriptionPlansPage"

# iOS (Simulator)
xcrun simctl openurl booted "rupiesempresa://rupiesempresa.com/subscriptionPlansPage"
```

---

## 📝 Cenários de Teste

### Cenário 1: Visualizar Planos ✅

**Passos**:
1. Navegar para `/subscriptionPlansPage`
2. Verificar que os planos carregam da database
3. Alternar entre "Mensal" e "Anual"
4. Verificar que os preços mudam

**Resultado Esperado**:
- ✅ Header com gradiente e título "Clube dos 100"
- ✅ Toggle Mensal/Anual funcional
- ✅ Lista de planos com cards
- ✅ Preços formatados corretamente (R$ XX.XX)
- ✅ Seleção visual ao clicar em um plano
- ✅ Botão "Continuar para Pagamento" habilitado

**Verificação**:
```dart
// Console logs esperados:
✅ Carregando planos...
✅ X planos carregados
```

---

### Cenário 2: Selecionar Plano e Criar Subscription ✅

**Passos**:
1. Selecionar um plano (clicar no card)
2. Verificar visual feedback (borda primary, ícone check)
3. Selecionar "Mensal" ou "Anual"
4. Clicar em "Continuar para Pagamento"

**Resultado Esperado**:
- ✅ Loading state (botão mostra "Processando...")
- ✅ Chamada para Edge Function `create-asaas-subscription`
- ✅ Navegação para `SubscriptionCheckoutPage`
- ✅ Dados de pagamento passados via queryParameters

**Verificação**:
```dart
// Console logs esperados:
🚀 Criando assinatura...
   Plan ID: [uuid]
   Billing Cycle: monthly
   Payment Method: pix
📤 Enviando requisição...
📊 Status code: 200
✅ Assinatura criada com sucesso!
```

**Possíveis Erros**:
- ❌ Error 401: Token JWT inválido
- ❌ Error 500: Edge Function com erro
- ❌ Nenhum plano selecionado: Mostra SnackBar

---

### Cenário 3: Checkout com PIX ✅

**Passos**:
1. Após criar subscription, verificar página de checkout
2. Verificar display do QR Code (placeholder)
3. Copiar código PIX
4. Verificar instruções

**Resultado Esperado**:
- ✅ Header "Assinatura Criada!"
- ✅ Seção PIX visível
- ✅ Placeholder de QR Code (ícone)
- ✅ Código PIX copy & paste
- ✅ Botão copiar funcional (mostra SnackBar "Código PIX copiado!")
- ✅ Instruções de pagamento
- ✅ Botão "Já Paguei"
- ✅ Botão "Voltar"

**Verificação**:
```dart
// subscriptionData deve conter:
{
  "subscription": { ... },
  "payment": {
    "pixQrCode": "data:image/png;base64,...",
    "pixCopyPaste": "00020126...",
    "dueDate": "2025-01-08",
    "value": 99.90
  }
}
```

---

### Cenário 4: Checkout com Boleto ✅

**Passos**:
1. Criar subscription com `paymentMethod: 'boleto'`
2. Verificar seção de Boleto
3. Clicar em "Abrir Boleto"

**Resultado Esperado**:
- ✅ Seção Boleto visível
- ✅ Ícone de recibo
- ✅ Texto "Seu boleto está pronto!"
- ✅ Botão "Abrir Boleto" abre URL
- ✅ Instruções de pagamento

**Verificação**:
```dart
// subscriptionData deve conter:
{
  "payment": {
    "invoiceUrl": "https://sandbox.asaas.com/i/...",
    ...
  }
}
```

---

### Cenário 5: Verificar Pagamento ✅

**Passos**:
1. Na página de checkout, clicar em "Já Paguei"
2. Aguardar chamada para `getSubscriptionStatus()`
3. Verificar resultado

**Resultado Esperado**:

**Se pagamento confirmado**:
- ✅ Navega para HomePage
- ✅ Subscription ativa

**Se pagamento pendente**:
- ✅ Mostra SnackBar amarelo "Aguardando confirmação do pagamento..."
- ✅ Permanece na página de checkout

**Verificação**:
```dart
// Console logs:
📊 Verificando status...
✅ Status recebido: { hasActiveSubscription: true/false }
```

---

### Cenário 6: Testar Custom Actions Isoladamente 🧪

Você pode testar as actions diretamente sem UI:

#### Test getSubscriptionStatus()

```dart
// Adicionar em qualquer página
ElevatedButton(
  onPressed: () async {
    final status = await getSubscriptionStatus();
    print('📊 Status: $status');

    if (status != null) {
      print('✅ Has Active: ${status['hasActiveSubscription']}');
      print('✅ Is Premium: ${status['isPremium']}');
      print('✅ Features: ${status['features']}');
    }
  },
  child: Text('Test Get Status'),
)
```

#### Test checkSubscription()

```dart
ElevatedButton(
  onPressed: () async {
    // Verificar subscription geral
    bool hasActive = await checkSubscription(null);
    print('Tem subscription? $hasActive');

    // Verificar feature específica
    bool hasFeature = await checkSubscription('unlimited_posts');
    print('Tem unlimited_posts? $hasFeature');
  },
  child: Text('Test Check'),
)
```

#### Test createSubscription()

```dart
ElevatedButton(
  onPressed: () async {
    // Buscar planos
    final plans = await SupaFlow.client
        .from('subscription_plans')
        .select('id, name')
        .eq('is_active', true);

    if (plans.isEmpty) {
      print('❌ Nenhum plano encontrado!');
      return;
    }

    String planId = plans.first['id'];
    print('📋 Usando plano: ${plans.first['name']}');

    // Criar subscription
    final result = await createSubscription(
      planId,
      'monthly',
      'pix',
    );

    print('📊 Resultado: $result');

    if (result != null && result['success'] != false) {
      print('✅ Subscription criada!');
      print('   PIX: ${result['payment']['pixCopyPaste']?.substring(0, 50)}...');
    } else {
      print('❌ Erro: ${result?['error']}');
    }
  },
  child: Text('Test Create'),
)
```

#### Test cancelSubscription()

```dart
ElevatedButton(
  onPressed: () async {
    // Buscar subscription ativa do usuário
    final status = await getSubscriptionStatus();

    if (status?['subscription'] == null) {
      print('❌ Nenhuma subscription ativa');
      return;
    }

    String subId = status['subscription']['id'];

    // Cancelar ao fim do período
    final result = await cancelSubscription(
      subId,
      false, // immediate
      'Testando cancelamento',
    );

    print('📊 Resultado: $result');

    if (result != null && result['success'] != false) {
      print('✅ Cancelado!');
      print('   Ends at: ${result['endsAt']}');
    }
  },
  child: Text('Test Cancel'),
)
```

---

## 🔍 Verificações no Database

### Verificar Subscription Criada

```sql
SELECT
  s.id,
  s.status,
  s.billing_cycle,
  s.current_period_start,
  s.current_period_end,
  s.asaas_subscription_id,
  p.name as plan_name
FROM subscriptions s
INNER JOIN subscription_plans p ON p.id = s.plan_id
WHERE s.user_id = '[SEU_USER_ID]'
ORDER BY s.created_at DESC
LIMIT 1;
```

### Verificar Payment Transaction

```sql
SELECT
  pt.id,
  pt.subscription_id,
  pt.status,
  pt.amount,
  pt.payment_method,
  pt.asaas_payment_id,
  pt.due_date,
  pt.paid_date
FROM payment_transactions pt
WHERE pt.subscription_id = '[SUBSCRIPTION_ID]'
ORDER BY pt.created_at DESC;
```

### Verificar Features Ativas

```sql
SELECT * FROM get_active_features('[USER_ID]');
```

---

## 🐛 Troubleshooting

### Erro: "Usuário não autenticado"

**Causa**: Session JWT não válido

**Solução**:
```dart
// Verificar session
final session = await SupaFlow.client.auth.currentSession;
print('Session: ${session?.accessToken}');
```

### Erro: "Nenhum plano encontrado"

**Causa**: Tabela `subscription_plans` vazia

**Solução**: Executar seeds das migrations novamente

### Erro 500 na Edge Function

**Causa**: Edge Function com erro interno

**Solução**:
1. Verificar logs: `supabase functions logs create-asaas-subscription`
2. Verificar variáveis de ambiente (.env no Edge Function)

### QR Code não aparece

**Causa**: Package `qr_flutter` não instalado

**Solução**:
```bash
# Adicionar ao pubspec.yaml
qr_flutter: ^4.1.0

# Instalar
flutter pub get
```

Depois, substituir placeholder em [subscription_checkout_page_widget.dart:194](lib/subscription/subscription_checkout_page/subscription_checkout_page_widget.dart#L194)

---

## ✅ Checklist de Teste Completo

### Fase 1: Setup
- [ ] Database migrations executadas
- [ ] Edge Functions deployadas
- [ ] App compila sem erros
- [ ] Planos existem no database

### Fase 2: Navigation
- [ ] Consegue navegar para `/subscriptionPlansPage`
- [ ] Página carrega sem crash
- [ ] Toggle Mensal/Anual funciona

### Fase 3: Subscription Creation
- [ ] Consegue selecionar um plano
- [ ] Botão "Continuar" funciona
- [ ] Edge Function é chamada
- [ ] Navega para checkout

### Fase 4: Checkout PIX
- [ ] Página de checkout carrega
- [ ] Código PIX é exibido
- [ ] Botão copiar funciona
- [ ] Instruções estão visíveis

### Fase 5: Checkout Boleto
- [ ] Seção boleto aparece (quando payment_method = 'boleto')
- [ ] Botão "Abrir Boleto" funciona
- [ ] URL abre no navegador

### Fase 6: Payment Verification
- [ ] Botão "Já Paguei" funciona
- [ ] Chama `getSubscriptionStatus()`
- [ ] Navega ou mostra mensagem corretamente

### Fase 7: Database
- [ ] Subscription criada no database
- [ ] Payment transaction criada
- [ ] Status correto

---

## 📊 Métricas de Sucesso

**✅ 100% Funcional**:
- Todas as páginas carregam
- Navegação funciona
- Edge Functions respondem
- Database atualiza

**⚠️ Parcialmente Funcional**:
- UI funciona mas Edge Functions com erro
- Dados salvos mas status incorreto

**❌ Não Funcional**:
- Páginas crasham
- Edge Functions não respondem
- Database não atualiza

---

## 🎯 Próximos Passos Após Teste

1. **Se tudo funciona**:
   - ✅ Adicionar package `qr_flutter`
   - ✅ Criar Subscription Management Page
   - ✅ Integrar no menu principal
   - ✅ Criar widgets reutilizáveis

2. **Se houver erros**:
   - 🔍 Verificar logs
   - 🐛 Corrigir bugs
   - 🧪 Testar novamente

---

## 📖 Documentação Relacionada

- [FASE_3_PROGRESO.md](./FASE_3_PROGRESO.md) - Progresso da Fase 3
- [FASE_3_FLUTTER_UI.md](./FASE_3_FLUTTER_UI.md) - Plan completo
- [PLANO_CLUBE_100_ASAAS.md](./PLANO_CLUBE_100_ASAAS.md) - Visão geral

---

**Última actualización**: 2025-01-02
**Autor**: Claude Code
