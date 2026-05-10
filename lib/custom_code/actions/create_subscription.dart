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

Future<dynamic> createSubscription(
  String planId,
  String billingCycle,
  String paymentMethod,
) async {
  try {
    final session = SupaFlow.client.auth.currentSession;
    if (session == null) {
      return {'success': false, 'error': 'Usuário não autenticado'};
    }

    final token = session.accessToken;
    final url = Uri.parse(
        'https://ejnzgjczritznohpdnxl.supabase.co/functions/v1/create-subscription');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'planId': planId,
        'billingCycle': billingCycle,
        'paymentMethod': paymentMethod,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == true) {
        final data = jsonResponse['data'];
        if (data is Map<String, dynamic>) {
          return {...data, 'success': true};
        }
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'error': jsonResponse['error'] ?? 'Erro desconhecido',
        };
      }
    } else {
      try {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorResponse['error'] ?? 'Erro ao criar assinatura',
        };
      } catch (e) {
        return {'success': false, 'error': 'Erro ao criar assinatura'};
      }
    }
  } catch (e) {
    debugPrint('createSubscription error: $e');
    return {'success': false, 'error': 'Erro: $e'};
  }
}
