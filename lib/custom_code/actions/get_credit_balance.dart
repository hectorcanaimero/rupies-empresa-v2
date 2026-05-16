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

const _unset = Object();

/// Retorna o saldo de créditos atual do usuário.
///
/// Retorna um Map com:
/// - hasBalance (bool): se existe balanço ativo
/// - creditsRemaining (int): créditos disponíveis
/// - creditsGranted (int): créditos concedidos no período
/// - creditsUsed (int): créditos consumidos
/// - isUnlimited (bool): true para plano ilimitado
/// - periodEnd (String?): data de fim do período atual
/// - plan (Map?): informações do plano ativo
Future<dynamic> getCreditBalance({
  http.Client? client,
  Object? authToken = _unset,
}) async {
  try {
    final token = authToken == _unset
        ? SupaFlow.client.auth.currentSession?.accessToken
        : authToken as String?;
    if (token == null) {
      return {
        'hasBalance': false,
        'creditsRemaining': 0,
        'creditsGranted': 0,
        'creditsUsed': 0,
        'isUnlimited': false,
        'periodEnd': null,
        'plan': null,
      };
    }

    final url = Uri.parse(
        'https://ejnzgjczritznohpdnxl.supabase.co/functions/v1/get-credit-balance');

    final c = client ?? http.Client();
    try {
      final response = await c.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          return jsonResponse['data'];
        }
        debugPrint('getCreditBalance error: ${jsonResponse['error']}');
      } else {
        debugPrint('getCreditBalance HTTP ${response.statusCode}');
      }
    } finally {
      if (client == null) c.close();
    }

    return {
      'hasBalance': false,
      'creditsRemaining': 0,
      'creditsGranted': 0,
      'creditsUsed': 0,
      'isUnlimited': false,
      'periodEnd': null,
      'plan': null,
    };
  } catch (e) {
    debugPrint('getCreditBalance error: $e');
    return {
      'hasBalance': false,
      'creditsRemaining': 0,
      'creditsGranted': 0,
      'creditsUsed': 0,
      'isUnlimited': false,
      'periodEnd': null,
      'plan': null,
    };
  }
}
