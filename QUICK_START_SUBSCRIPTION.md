# ⚡ Quick Start - Sistema de Assinaturas

**Tempo estimado**: 5 minutos
**Última atualização**: 2025-01-02

---

## 🚀 Teste Rápido em 3 Passos

### Paso 1: Agregar Botón de Teste (2 min)

Abra `lib/pages/home_page/home_page_widget.dart` e agregue este botón temporário:

```dart
// Buscar el método build() y agregar dentro del Scaffold:

FloatingActionButton(
  onPressed: () {
    context.pushNamed('SubscriptionPlansPage');
  },
  backgroundColor: FlutterFlowTheme.of(context).primary,
  child: Icon(Icons.star, color: Colors.white),
)
```

**Localización**: Dentro del `Scaffold`, después del `body:` o como `floatingActionButton:`

### Paso 2: Ejecutar el App (1 min)

```bash
cd /Users/al3jandro/project/rupies/rupies-empresa
flutter run
```

### Paso 3: Navegar y Testar (2 min)

1. ✅ Haga login en el app
2. ✅ Toque el botón estrella (⭐)
3. ✅ Debe abrir la página "Clube dos 100"
4. ✅ Seleccione un plan
5. ✅ Clique "Continuar para Pagamento"
6. ✅ Debe mostrar página de checkout con PIX

---

## 🎯 Navegación Directa (Sin modificar código)

### Opción A: Deep Link (Android)

```bash
adb shell am start -a android.intent.action.VIEW \
  -d "rupiesempresa://rupiesempresa.com/subscriptionPlansPage"
```

### Opción B: Deep Link (iOS Simulator)

```bash
xcrun simctl openurl booted \
  "rupiesempresa://rupiesempresa.com/subscriptionPlansPage"
```

---

## 📋 Verificaciones Rápidas

### ✅ El sistema está funcionando si:

1. **Página de Planos**:
   - Se ve header "Clube dos 100" con gradiente
   - Hay toggle "Mensal" / "Anual"
   - Se muestran cards de planos

2. **Selección de Plan**:
   - Al clicar, el card se destaca con borde azul
   - Aparece ícono ✓ de check
   - Botón "Continuar para Pagamento" se habilita

3. **Página de Checkout**:
   - Header "Assinatura Criada!"
   - Se muestra código PIX (como texto)
   - Hay botón copiar
   - Instrucciones de pago visibles

### ❌ Problemas Comunes

**"Nenhum plano encontrado"**
→ Database vacío. Ejecutar migrations.

**"Usuário não autenticado"**
→ Hacer login en el app primero.

**"Error al crear assinatura"**
→ Verificar Edge Functions deployadas.

---

## 🧪 Testar Custom Actions Directamente

Agregar estos botones en cualquier página para test rápido:

```dart
Column(
  children: [
    // Test 1: Get Status
    ElevatedButton(
      onPressed: () async {
        final status = await getSubscriptionStatus();
        print('Status: $status');
      },
      child: Text('1. Get Status'),
    ),

    // Test 2: Check Subscription
    ElevatedButton(
      onPressed: () async {
        bool has = await checkSubscription(null);
        print('Has subscription? $has');
      },
      child: Text('2. Check Sub'),
    ),

    // Test 3: Create (necesita plan ID)
    ElevatedButton(
      onPressed: () async {
        final plans = await SupaFlow.client
            .from('subscription_plans')
            .select('id')
            .eq('is_active', true)
            .limit(1);

        if (plans.isNotEmpty) {
          final result = await createSubscription(
            plans.first['id'],
            'monthly',
            'pix',
          );
          print('Created: $result');
        }
      },
      child: Text('3. Create Sub'),
    ),
  ],
)
```

---

## 📊 Logs Esperados (Console)

Al crear subscription, debe ver:

```
🚀 Criando assinatura...
   Plan ID: [uuid]
   Billing Cycle: monthly
   Payment Method: pix
📤 Enviando requisição...
📊 Status code: 200
📊 Response body: {"success":true,"data":{...}}
✅ Assinatura criada com sucesso!
```

---

## 🎨 Mejora: Agregar QR Code Real (Opcional)

Si quiere ver el QR Code visual en vez de placeholder:

### 1. Agregar package

```yaml
# pubspec.yaml
dependencies:
  qr_flutter: ^4.1.0
```

### 2. Instalar

```bash
flutter pub get
```

### 3. Ya está!

El código ya está preparado para usar qr_flutter. Solo descomentar en:
[subscription_checkout_page_widget.dart:194](lib/subscription/subscription_checkout_page/subscription_checkout_page_widget.dart#L194)

---

## 🔗 Links Útiles

- **Teste Completo**: [TESTE_SUBSCRIPTION_SYSTEM.md](./TESTE_SUBSCRIPTION_SYSTEM.md)
- **Progreso Fase 3**: [FASE_3_PROGRESO.md](./FASE_3_PROGRESO.md)
- **Plan General**: [PLANO_CLUBE_100_ASAAS.md](./PLANO_CLUBE_100_ASAAS.md)

---

## 🎯 Próximos Pasos Recomendados

Después de testar exitosamente:

1. **Agregar al Menu**:
   - Crear botón en menu_page para "Clube dos 100"
   - Navegar para SubscriptionPlansPage

2. **Agregar Package QR**:
   - Instalar qr_flutter
   - Ver QR Code visual

3. **Crear Management Page**:
   - Página para gerenciar subscription
   - Cancelar, ver histórico

---

**¿Todo funcionó?** 🎉

Si todas las verificaciones pasaron, su sistema de assinaturas está **100% funcional**!

Puede continuar con las mejoras opcionales o empezar a integrar en el flujo principal del app.
