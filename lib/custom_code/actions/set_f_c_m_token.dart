// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import "package:utility_functions_library_8g4bud/backend/schema/structs/index.dart"
    as utility_functions_library_8g4bud_data_schema;
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future setFCMToken() async {
  try {
    // Asegurar que Firebase está inicializado
    await Firebase.initializeApp();

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Solicitar permisos de notificaciones
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // Verificar si se otorgaron los permisos
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {

      // Obtener el token FCM
      String? fcmToken = await messaging.getToken();

      if (fcmToken != null && fcmToken.isNotEmpty) {
        // Guardar en FFAppState (se persiste automáticamente en secure storage)
        FFAppState().fcmToken = fcmToken;

        // TODO: Descomentar cuando la columna fcm_token exista en Supabase
        // Guardar el token en Supabase para el usuario actual
        // final userId = currentUserUid;
        // if (userId != null && userId.isNotEmpty) {
        //   await SupaFlow.client
        //     .from('users') // o 'profiles' según tu schema
        //     .update({'fcm_token': fcmToken})
        //     .eq('id', userId);
        // }

        print('FCM Token obtenido y guardado exitosamente');
      } else {
        print('Error: No se pudo obtener el FCM token');
      }
    } else {
      print('Permisos de notificaciones no otorgados');
    }
  } catch (e) {
    print('Error al configurar FCM token: $e');
    // No guardamos el error en fcmToken para evitar sobrescribir un token válido
  }
}
