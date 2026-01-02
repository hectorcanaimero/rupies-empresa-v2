# 📱 Fase 3: Flutter UI - Clube dos 100

## 🎯 Objetivo

Implementar las pantallas y lógica de UI en Flutter para el sistema de assinaturas, integrando con las Edge Functions creadas en Fase 2.

---

## 📋 Estructura de Archivos a Crear

```
lib/
├── subscription/                           # Nueva carpeta para subscriptions
│   ├── subscription_plans_page/
│   │   ├── subscription_plans_page_model.dart
│   │   └── subscription_plans_page_widget.dart
│   │
│   ├── subscription_checkout_page/
│   │   ├── subscription_checkout_page_model.dart
│   │   └── subscription_checkout_page_widget.dart
│   │
│   ├── subscription_management_page/
│   │   ├── subscription_management_page_model.dart
│   │   └── subscription_management_page_widget.dart
│   │
│   └── widgets/                            # Widgets compartidos
│       ├── subscription_plan_card.dart
│       ├── premium_badge_widget.dart
│       ├── feature_paywall_widget.dart
│       └── pix_qr_code_widget.dart
│
├── custom_code/
│   ├── actions/
│   │   ├── check_subscription.dart         # Verificar assinatura
│   │   ├── create_subscription.dart        # Crear assinatura
│   │   ├── cancel_subscription.dart        # Cancelar assinatura
│   │   └── get_subscription_status.dart    # Obtener status
│   │
│   └── widgets/
│       └── (widgets si se necesitan más personalizados)
│
└── backend/
    └── supabase/
        └── supabase_manager.dart           # Extender con subscription methods
```

---

## 🎨 Pantallas a Implementar

### 1. Subscription Plans Page

**Archivo**: `lib/subscription/subscription_plans_page/subscription_plans_page_widget.dart`

**Funcionalidad**:
- Mostrar 3 planos (Grátis, Mensal, Anual)
- Comparación de features
- Highlight del plan recomendado
- Botón "Assinar" para cada plan
- Feature flag check (`show_premium_features`)

**Design**:
```
┌─────────────────────────────────────┐
│  Clube dos 100                      │
│  Benefícios Exclusivos              │
├─────────────────────────────────────┤
│                                     │
│  ┌───────┐  ┌───────┐  ┌───────┐  │
│  │Grátis │  │Mensal │  │ Anual │  │
│  │ R$0   │  │R$99.90│  │R$79.92│  │
│  │       │  │  /mês │  │  /mês │  │
│  │       │  │       │  │       │  │
│  │ Free  │  │Premium│  │Premium│  │
│  │       │  │       │  │20% OFF│  │
│  │       │  │       │  │       │  │
│  │[Atual]│  │[Assinar]│[Assinar]│  │
│  └───────┘  └───────┘  └───────┘  │
│                                     │
│  Features incluídas:                │
│  ✓ Serviços ilimitados              │
│  ✓ Contatos ilimitados              │
│  ✓ Suporte prioritário              │
│  ✓ Badge Premium                    │
│  ✓ Destaque nas buscas              │
│                                     │
└─────────────────────────────────────┘
```

---

### 2. Subscription Checkout Page

**Archivo**: `lib/subscription/subscription_checkout_page/subscription_checkout_page_widget.dart`

**Funcionalidade**:
- Resumo do plano selecionado
- Escolha do método de pagamento (PIX/Boleto/Cartão)
- Exibição de QR Code PIX
- Link do Boleto
- Status do pagamento
- Botão "Concluir"

**Flow**:
```
1. Resumo do Plano
   ┌─────────────────────┐
   │ Clube dos 100       │
   │ Plano Mensal        │
   │ R$ 99,90 / mês      │
   └─────────────────────┘

2. Escolher Pagamento
   ○ PIX
   ○ Boleto
   ○ Cartão de Crédito

3. Se PIX:
   ┌─────────────────────┐
   │  [QR Code]          │
   │                     │
   │  Copiar Código      │
   │  [Código PIX...]    │
   │                     │
   │  Aguardando...      │
   └─────────────────────┘

4. Se Boleto:
   ┌─────────────────────┐
   │  Boleto Bancário    │
   │                     │
   │  Vencimento:        │
   │  08/01/2025         │
   │                     │
   │  [Baixar Boleto]    │
   │  [Copiar Código]    │
   └─────────────────────┘
```

---

### 3. Subscription Management Page

**Archivo**: `lib/subscription/subscription_management_page/subscription_management_page_widget.dart`

**Funcionalidade**:
- Status atual da assinatura
- Detalhes do plano
- Data de renovação
- Histórico de pagamentos
- Botão "Cancelar assinatura"
- Upgrade/Downgrade de plano

**Design**:
```
┌─────────────────────────────────────┐
│  Minha Assinatura                   │
├─────────────────────────────────────┤
│                                     │
│  Status: ✅ Ativa                   │
│  Plano: Clube dos 100 - Mensal      │
│  Valor: R$ 99,90 / mês              │
│  Próximo pagamento: 01/02/2025      │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Usar Features Premium       │   │
│  │ ✓ Serviços ilimitados       │   │
│  │ ✓ Contatos ilimitados       │   │
│  └─────────────────────────────┘   │
│                                     │
│  Histórico de Pagamentos            │
│  ┌─────────────────────────────┐   │
│  │ 01/01/2025  PIX  R$ 99,90   │   │
│  │ Status: Pago                │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Alterar Plano]                    │
│  [Cancelar Assinatura]              │
│                                     │
└─────────────────────────────────────┘
```

---

## 🔧 Custom Actions a Implementar

### 1. check_subscription.dart

**Purpose**: Verificar se usuário tem assinatura ativa

```dart
Future<bool> checkSubscription(String? featureKey) async {
  final userId = currentUserUid;
  if (userId == null) return false;

  try {
    final response = await http.get(
      Uri.parse('${FFAppConstants.supabaseUrl}/functions/v1/get-subscription-status'),
      headers: {
        'Authorization': 'Bearer ${currentJWT}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (featureKey != null) {
        return data['data']['features'].contains(featureKey);
      }
      return data['data']['hasActiveSubscription'] ?? false;
    }
    return false;
  } catch (e) {
    print('Error checking subscription: $e');
    return false;
  }
}
```

---

### 2. create_subscription.dart

**Purpose**: Crear nueva assinatura

```dart
Future<Map<String, dynamic>?> createSubscription({
  required String planId,
  required String billingCycle,
  required String paymentMethod,
}) async {
  try {
    final response = await http.post(
      Uri.parse('${FFAppConstants.supabaseUrl}/functions/v1/create-asaas-subscription'),
      headers: {
        'Authorization': 'Bearer ${currentJWT}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'planId': planId,
        'billingCycle': billingCycle,
        'paymentMethod': paymentMethod,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    }
    throw Exception('Failed to create subscription');
  } catch (e) {
    print('Error creating subscription: $e');
    return null;
  }
}
```

---

### 3. cancel_subscription.dart

**Purpose**: Cancelar assinatura

```dart
Future<bool> cancelSubscription({
  required String subscriptionId,
  bool immediate = false,
  String? reason,
}) async {
  try {
    final response = await http.post(
      Uri.parse('${FFAppConstants.supabaseUrl}/functions/v1/cancel-subscription'),
      headers: {
        'Authorization': 'Bearer ${currentJWT}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'subscriptionId': subscriptionId,
        'immediate': immediate,
        'reason': reason,
      }),
    );

    return response.statusCode == 200;
  } catch (e) {
    print('Error canceling subscription: $e');
    return false;
  }
}
```

---

### 4. get_subscription_status.dart

**Purpose**: Obtener status completo de la assinatura

```dart
Future<Map<String, dynamic>?> getSubscriptionStatus() async {
  try {
    final response = await http.get(
      Uri.parse('${FFAppConstants.supabaseUrl}/functions/v1/get-subscription-status'),
      headers: {
        'Authorization': 'Bearer ${currentJWT}',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    }
    return null;
  } catch (e) {
    print('Error getting subscription status: $e');
    return null;
  }
}
```

---

## 🎨 Widgets Compartidos

### 1. premium_badge_widget.dart

**Purpose**: Badge "Premium" para mostrar em usuários assinantes

```dart
class PremiumBadgeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 14, color: Colors.white),
          SizedBox(width: 4),
          Text(
            'PREMIUM',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
```

---

### 2. feature_paywall_widget.dart

**Purpose**: Bloquear features premium

```dart
class FeaturePaywallWidget extends StatelessWidget {
  final String featureName;
  final VoidCallback onUpgrade;

  FeaturePaywallWidget({
    required this.featureName,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.lock, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Feature Premium',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Assine o Clube dos 100 para acessar $featureName',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: onUpgrade,
            child: Text('Conhecer Planos'),
          ),
        ],
      ),
    );
  }
}
```

---

## 🔄 Integração com Feature Flag

**Verificar se deve mostrar paywall**:

```dart
Future<bool> shouldShowPremiumFeatures() async {
  final response = await SupaFlow.client
      .from('feature_flags')
      .select('is_enabled')
      .eq('flag_key', 'show_premium_features')
      .single();

  return response['is_enabled'] ?? false;
}
```

**Uso en las páginas**:

```dart
@override
void initState() {
  super.initState();
  _checkFeatureFlag();
}

Future<void> _checkFeatureFlag() async {
  final showPremium = await shouldShowPremiumFeatures();
  setState(() {
    _showPremiumFeatures = showPremium;
  });
}

@override
Widget build(BuildContext context) {
  if (!_showPremiumFeatures) {
    // No mostrar paywall ni opciones de assinatura
    return SizedBox.shrink();
  }

  // Mostrar normalmente
  return SubscriptionUI();
}
```

---

## 📱 Navegación

**Agregar rutas en router**:

```dart
// Subscription Plans
'/subscription-plans': (context) => SubscriptionPlansPageWidget(),

// Checkout
'/subscription-checkout': (context) => SubscriptionCheckoutPageWidget(),

// Management
'/subscription-management': (context) => SubscriptionManagementPageWidget(),
```

**Navegar desde la app**:

```dart
// Desde cualquier parte
context.pushNamed('subscription-plans');

// Con parámetros
context.pushNamed('subscription-checkout', extra: {
  'planId': selectedPlan.id,
  'billingCycle': 'monthly',
});
```

---

## ✅ Checklist de Implementación

### Páginas
- [ ] SubscriptionPlansPage (listar planos)
- [ ] SubscriptionCheckoutPage (pagar)
- [ ] SubscriptionManagementPage (gerenciar)

### Custom Actions
- [ ] check_subscription.dart
- [ ] create_subscription.dart
- [ ] cancel_subscription.dart
- [ ] get_subscription_status.dart

### Widgets
- [ ] SubscriptionPlanCard
- [ ] PremiumBadgeWidget
- [ ] FeaturePaywallWidget
- [ ] PixQrCodeWidget

### Integración
- [ ] Feature flag check
- [ ] Rutas de navegación
- [ ] Deep links (si aplica)

### Testing
- [ ] Flow completo: seleccionar → pagar → gerenciar
- [ ] Feature flag ON/OFF
- [ ] PIX, Boleto, Cartão
- [ ] Cancelamento

---

## 🎯 Prioridades

**Alta Prioridad** (MVP):
1. Custom Actions (integración con API)
2. SubscriptionPlansPage
3. SubscriptionCheckoutPage (solo PIX inicialmente)
4. Feature flag integration

**Media Prioridad**:
5. SubscriptionManagementPage
6. PremiumBadgeWidget
7. Checkout con Boleto

**Baja Prioridad** (nice-to-have):
8. FeaturePaywallWidget
9. Checkout con Cartão
10. Upgrade/Downgrade de plano

---

## 📖 Próximo Paso

¿Quieres que empiece con:

**A)** Custom Actions (la base para todo)
**B)** SubscriptionPlansPage (la primera pantalla)
**C)** Ambos en paralelo

---

**Creado**: 2025-01-02
**Status**: Plan completo, listo para implementar
**Duración estimada**: 2-3 días
