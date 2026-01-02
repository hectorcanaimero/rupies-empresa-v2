# Configuración de Push Notifications - Rupies Empresas

Esta guía documenta la configuración completa de Firebase Cloud Messaging (FCM) para push notifications en la app Rupies Empresas.

## ✅ Implementaciones Completadas

### 1. Persistencia del FCM Token
- **Archivo**: `lib/app_state.dart`
- **Cambios**:
  - El `fcmToken` ahora se guarda automáticamente en `flutter_secure_storage`
  - Se inicializa al arrancar la app desde el storage
  - Método `deleteFcmToken()` agregado para limpieza

### 2. Custom Action Mejorada
- **Archivo**: `lib/custom_code/actions/set_f_c_m_token.dart`
- **Mejoras**:
  - ✅ Eliminado código de debugging que sobrescribía el token
  - ✅ Manejo de errores mejorado con try-catch
  - ✅ Soporte para permisos provisionales en iOS
  - ✅ Token se persiste automáticamente vía FFAppState
  - ⏳ Preparado para guardar en Supabase (comentado, ver paso 4)

### 3. Servicio de Notificaciones
- **Archivo**: `lib/services/notification_service.dart`
- **Funcionalidades**:
  - ✅ Handler para mensajes en foreground (app abierta)
  - ✅ Handler para cuando el usuario toca una notificación
  - ✅ Handler para actualización del token FCM
  - ✅ Métodos para actualizar/eliminar token en Supabase (preparados)
  - ⏳ TODO: Implementar navegación según data de notificación
  - ⏳ TODO: Mostrar notificaciones locales en foreground

### 4. Integración en Main
- **Archivo**: `lib/main.dart`
- **Cambios**:
  - ✅ Handler de background messages (`_firebaseMessagingBackgroundHandler`)
  - ✅ Inicialización del `NotificationService`
  - ✅ Configurado antes de ejecutar la app

## 📋 Configuración Adicional Requerida

### Paso 1: Agregar Columna en Supabase

Es necesario agregar una columna para almacenar el FCM token en la base de datos:

```sql
-- Opción 1: Si usas la tabla 'users'
ALTER TABLE users
ADD COLUMN fcm_token TEXT;

-- Opción 2: Si usas la tabla 'profiles'
ALTER TABLE profiles
ADD COLUMN fcm_token TEXT;

-- Crear índice para búsquedas rápidas
CREATE INDEX idx_users_fcm_token ON users(fcm_token);
-- O
CREATE INDEX idx_profiles_fcm_token ON profiles(fcm_token);
```

**Después de crear la columna:**

1. Descomentar el código en `lib/custom_code/actions/set_f_c_m_token.dart` (líneas 44-52)
2. Descomentar el código en `lib/services/notification_service.dart` (métodos `updateTokenInSupabase`)
3. Ajustar la tabla ('users' o 'profiles') según tu schema

### Paso 2: Configurar iOS Capabilities

En Xcode, habilitar las siguientes capabilities:

1. Abrir `ios/Runner.xcworkspace` en Xcode
2. Seleccionar el target "Runner"
3. Ir a "Signing & Capabilities"
4. Agregar las siguientes capabilities:
   - **Push Notifications**
   - **Background Modes** → Marcar:
     - Remote notifications
     - Background fetch (opcional)

### Paso 3: Configurar APNs en Firebase Console

Para que las notificaciones funcionen en iOS:

1. Ir a [Firebase Console](https://console.firebase.google.com)
2. Seleccionar el proyecto "rupies-brasil"
3. Ir a Project Settings → Cloud Messaging
4. En la sección "Apple app configuration":
   - Subir tu certificado APNs (.p8) o .p12
   - O configurar APNs Authentication Key

**Generar APNs Key (recomendado):**
1. Ir a [Apple Developer](https://developer.apple.com/account/resources/authkeys/list)
2. Crear una nueva Key con servicio "Apple Push Notifications service (APNs)"
3. Descargar el archivo .p8
4. Subir a Firebase Console con el Key ID y Team ID

### Paso 4: Configurar Notification Icon en Android

Para personalizar el ícono de notificaciones en Android:

1. Crear archivo `android/app/src/main/res/drawable/ic_notification.xml`:

```xml
<?xml version="1.0" encoding="utf-8"?>
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="24dp"
    android:height="24dp"
    android:viewportWidth="24"
    android:viewportHeight="24">
    <path
        android:fillColor="#FFFFFF"
        android:pathData="M12,2C6.48,2 2,6.48 2,12s4.48,10 10,10 10,-4.48 10,-10S17.52,2 12,2zM12,20c-4.41,0 -8,-3.59 -8,-8s3.59,-8 8,-8 8,3.59 8,8 -3.59,8 -8,8z"/>
</vector>
```

2. Actualizar `AndroidManifest.xml` para usar este ícono:

```xml
<application ...>
    <meta-data
        android:name="com.google.firebase.messaging.default_notification_icon"
        android:resource="@drawable/ic_notification" />
    <meta-data
        android:name="com.google.firebase.messaging.default_notification_color"
        android:resource="@color/colorPrimary" />
</application>
```

### Paso 5: Configurar Notification Channels (Android 8.0+)

Crear channels para categorizar notificaciones. Agregar en `NotificationService`:

```dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

static final FlutterLocalNotificationsPlugin _localNotifications =
    FlutterLocalNotificationsPlugin();

static Future<void> _setupLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@drawable/ic_notification');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

  const InitializationSettings initializationSettings =
      InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

  await _localNotifications.initialize(initializationSettings);

  // Crear notification channels
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'rupies_channel', // id
    'Notificaciones de Rupies', // nombre
    description: 'Canal para notificaciones importantes de Rupies',
    importance: Importance.high,
  );

  await _localNotifications
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}
```

## 🧪 Cómo Probar

### Test Manual

1. **Ejecutar la app**:
```bash
flutter run
```

2. **Llamar al custom action `setFCMToken`** desde FlutterFlow o código:
   - Esto solicitará permisos y obtendrá el token

3. **Verificar el token**:
```dart
print('FCM Token: ${FFAppState().fcmToken}');
```

4. **Enviar notificación de prueba** desde Firebase Console:
   - Ir a Cloud Messaging → Send test message
   - Pegar el FCM token
   - Enviar

### Test con Firebase Console

1. Ir a Firebase Console → Cloud Messaging
2. Click en "Send your first message"
3. Ingresar título y mensaje
4. Click "Send test message"
5. Pegar el FCM token del dispositivo
6. Click "Test"

### Test Programático

Crear un Cloud Function para enviar notificaciones:

```javascript
// firebase/functions/index.js
const admin = require('firebase-admin');

exports.sendNotification = functions.https.onCall(async (data, context) => {
  const { token, title, body, data: extraData } = data;

  const message = {
    notification: {
      title: title,
      body: body,
    },
    data: extraData || {},
    token: token,
  };

  try {
    const response = await admin.messaging().send(message);
    return { success: true, messageId: response };
  } catch (error) {
    throw new functions.https.HttpsError('internal', error.message);
  }
});
```

## 📊 Estados de Notificaciones

| Estado de la App | Handler | Archivo |
|------------------|---------|---------|
| **Foreground** (abierta) | `FirebaseMessaging.onMessage` | `notification_service.dart:24` |
| **Background** (minimizada) | `_firebaseMessagingBackgroundHandler` | `main.dart:23` |
| **Terminated** (cerrada) | `_firebaseMessagingBackgroundHandler` | `main.dart:23` |
| **Tap en notificación** | `FirebaseMessaging.onMessageOpenedApp` | `notification_service.dart:28` |

## 🔧 Troubleshooting

### No recibo notificaciones en iOS

1. Verificar que APNs esté configurado en Firebase Console
2. Verificar capabilities en Xcode
3. Revisar que el bundle ID coincida
4. Verificar permisos: `Settings → Rupies Empresas → Notifications`

### No recibo notificaciones en Android

1. Verificar que `google-services.json` esté actualizado
2. Verificar que el `applicationId` coincida con Firebase
3. Revisar permisos de notificaciones (Android 13+)
4. Verificar logs: `adb logcat | grep FCM`

### El token es null o vacío

1. Verificar conexión a internet
2. Verificar que Firebase esté inicializado correctamente
3. En iOS, verificar APNs configuration
4. Revisar logs para errores

### Token se pierde al cerrar la app

✅ **Ya está solucionado** - El token ahora se persiste en secure storage

## 📚 Recursos

- [Firebase Cloud Messaging Docs](https://firebase.google.com/docs/cloud-messaging)
- [FlutterFire Messaging](https://firebase.flutter.dev/docs/messaging/overview)
- [Apple Push Notifications](https://developer.apple.com/documentation/usernotifications)
- [Android Notification Channels](https://developer.android.com/develop/ui/views/notifications/channels)

## 🚀 Próximos Pasos

1. ✅ Completar configuración de Supabase (agregar columna)
2. ✅ Configurar APNs en Firebase Console
3. ✅ Testear en dispositivos reales iOS y Android
4. ⏳ Implementar navegación según tipo de notificación
5. ⏳ Agregar notificaciones locales para foreground
6. ⏳ Implementar analytics de notificaciones
7. ⏳ Crear Cloud Functions para envío automático

---

**Última actualización**: 2025-12-28
**Desarrollado por**: Ale - Flutter Developer
