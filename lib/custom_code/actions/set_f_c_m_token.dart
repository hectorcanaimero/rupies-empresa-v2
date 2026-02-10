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

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future setFCMToken() async {
  if (isWeb) return;

  final FirebaseMessaging fbMessaging = FirebaseMessaging.instance;

  try {
    final NotificationSettings settings = await fbMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      debugPrint('Permisos de notificación no concedidos');
      return;
    }

    await _initializeLocalNotifications();
    _setupFirebaseListeners();

    final String? token = await fbMessaging.getToken();
    if (token != null) {
      try {
        FFAppState().fcmToken = token;
      } catch (e) {
        debugPrint('FFAppState no inicializado aún: $e');
      }

      if (Platform.isIOS) {
        try {
          await fbMessaging.getAPNSToken();
        } catch (e) {
          debugPrint('Error obteniendo APNs token: $e');
        }
      }
    }
  } catch (e) {
    debugPrint('Error general en setFCMToken: $e');
  }
}

// --------------------
// NOTIFICACIONES LOCALES
// --------------------

Future<void> _initializeLocalNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null && response.payload!.isNotEmpty) {
        _handleNotificationClick(response.payload!);
      }
    },
  );
}

// --------------------
// FIREBASE LISTENERS
// --------------------

void _setupFirebaseListeners() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      await _showNotification(
        notification.title ?? 'Notificación',
        notification.body ?? '',
        data['imageUrl'],
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    final route = message.data['route'] ?? '';
    _handleNotificationClick(route);
  });

  FirebaseMessaging.onBackgroundMessage(_fbMessagingBackgroundHandler);
}

// --------------------
// MOSTRAR NOTIFICACIÓN
// --------------------

Future<void> _showNotification(
  String title,
  String body,
  String? imageUrl,
) async {
  BigPictureStyleInformation? bigPictureStyle;

  if (imageUrl != null && imageUrl.isNotEmpty) {
    try {
      final ByteArrayAndroidBitmap bigPicture = await _downloadImage(imageUrl);
      bigPictureStyle = BigPictureStyleInformation(
        bigPicture,
        largeIcon: bigPicture,
        contentTitle: title,
        summaryText: body,
      );
    } catch (e) {
      debugPrint('Error cargando imagen: $e');
    }
  }

  final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'default_channel_id',
    'Default Channel',
    channelDescription: 'Canal predeterminado',
    importance: Importance.max,
    priority: Priority.high,
    styleInformation: bigPictureStyle,
  );

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

  final NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails, iOS: iosDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformDetails,
  );
}

// --------------------
// DESCARGAR IMAGEN
// --------------------

Future<ByteArrayAndroidBitmap> _downloadImage(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return ByteArrayAndroidBitmap(response.bodyBytes);
  } else {
    throw Exception('Error descargando imagen: ${response.statusCode}');
  }
}

// --------------------
// BACKGROUND HANDLER
// --------------------

Future<void> _fbMessagingBackgroundHandler(RemoteMessage message) async {
  final data = message.data;
  await _showNotification(
    data['title'] ?? 'Notificación',
    data['body'] ?? '',
    data['imageUrl'],
  );
}

// --------------------
// CLICK EN NOTIFICACIÓN
// --------------------

void _handleNotificationClick(String route) {
  if (route.isNotEmpty) {
    try {
      FFAppState().initialRoute = route;
    } catch (e) {
      debugPrint('No se pudo setear initialRoute: $e');
    }
  }
}
