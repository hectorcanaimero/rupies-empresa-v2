import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/app_state.dart';
import '/backend/supabase/supabase.dart';

/// Servicio centralizado para manejar notificaciones push de Firebase
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  /// Inicializar el servicio de notificaciones
  static Future<void> initialize() async {
    if (kIsWeb) {
      // Las notificaciones push no están completamente soportadas en web
      print('Push notifications no disponibles en web');
      return;
    }

    try {
      final messaging = FirebaseMessaging.instance;

      // Configurar handler para mensajes en foreground (app abierta)
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Configurar handler para cuando el usuario toca una notificación
      // y la app estaba en background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Verificar si la app se abrió desde una notificación
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }

      // Listener para cuando el token se actualiza
      messaging.onTokenRefresh.listen((newToken) {
        _handleTokenRefresh(newToken);
      });

      print('NotificationService inicializado correctamente');
    } catch (e) {
      print('Error al inicializar NotificationService: $e');
    }
  }

  /// Maneja mensajes recibidos cuando la app está en foreground
  static void _handleForegroundMessage(RemoteMessage message) {
    print('📱 Mensaje recibido en foreground:');
    print('  Título: ${message.notification?.title}');
    print('  Cuerpo: ${message.notification?.body}');
    print('  Data: ${message.data}');

    // TODO: Mostrar una notificación local o un snackbar
    // Puedes usar el paquete flutter_local_notifications para mostrar
    // una notificación cuando la app está abierta
  }

  /// Maneja cuando el usuario toca una notificación
  static void _handleNotificationTap(RemoteMessage message) {
    print('👆 Usuario tocó la notificación:');
    print('  Título: ${message.notification?.title}');
    print('  Data: ${message.data}');

    // TODO: Navegar a la pantalla correspondiente según los datos
    // Ejemplo:
    // if (message.data.containsKey('screen')) {
    //   final screen = message.data['screen'];
    //   if (screen == 'chat') {
    //     context.pushNamed('ChatPage', extra: message.data);
    //   }
    // }
  }

  /// Maneja la actualización del token FCM
  static void _handleTokenRefresh(String newToken) {
    print('🔄 Token FCM actualizado: $newToken');

    // Guardar el nuevo token en FFAppState (se persiste automáticamente)
    FFAppState().fcmToken = newToken;

    // TODO: Actualizar el token en Supabase
    // _updateTokenInSupabase(newToken);
  }

  /// Actualiza el token FCM en la base de datos de Supabase
  ///
  /// IMPORTANTE: Esta función requiere que tengas una columna 'fcm_token'
  /// en tu tabla de usuarios en Supabase
  static Future<void> updateTokenInSupabase(String token) async {
    try {
      // TODO: Descomentar cuando la columna fcm_token exista en Supabase
      // final userId = currentUserUid;
      // if (userId == null || userId.isEmpty) {
      //   print('No hay usuario autenticado para actualizar el token');
      //   return;
      // }
      //
      // await SupaFlow.client
      //   .from('users') // o 'profiles' según tu schema
      //   .update({'fcm_token': token})
      //   .eq('id', userId);
      //
      // print('Token FCM actualizado en Supabase');
    } catch (e) {
      print('Error al actualizar token en Supabase: $e');
    }
  }

  /// Elimina el token FCM del dispositivo y de la base de datos
  static Future<void> deleteToken() async {
    try {
      if (kIsWeb) return;

      final messaging = FirebaseMessaging.instance;
      await messaging.deleteToken();

      FFAppState().deleteFcmToken();

      // TODO: Eliminar también de Supabase
      // await SupaFlow.client
      //   .from('users')
      //   .update({'fcm_token': null})
      //   .eq('id', currentUserUid);

      print('Token FCM eliminado correctamente');
    } catch (e) {
      print('Error al eliminar token FCM: $e');
    }
  }
}
