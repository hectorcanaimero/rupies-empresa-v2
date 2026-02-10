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

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> getSubscriptionStatus() async {
  try {
    // Obter token JWT do usuário atual
    final session = await SupaFlow.client.auth.currentSession;
    if (session == null) {
      print('❌ No hay sesión activa');
      return null;
    }

    final token = session.accessToken;

    // URL da Edge Function
    final url = Uri.parse(
        'https://ejnzgjczritznohpdnxl.supabase.co/functions/v1/get-subscription-history');

    // Fazer requisição
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('📊 Status code: ${response.statusCode}');
    print('📊 Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'] == true) {
        return jsonResponse['data'];
      } else {
        print('❌ Error en respuesta: ${jsonResponse['error']}');
        return null;
      }
    } else {
      print('❌ Error HTTP: ${response.statusCode}');
      print('❌ Body: ${response.body}');
      return null;
    }
  } catch (e) {
    print('❌ Exception en getSubscriptionStatus: $e');
    return null;
  }
}
