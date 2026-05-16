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

// Sentinel for "authToken not provided by caller" — distinguishes from explicit null.
const _unset = Object();

/// Resultado do consumo de crédito
class ConsumeCreditResult {
  final bool success;
  final int creditsRemaining;
  final bool isUnlimited;
  final String? error; // 'insufficient_credits' | 'no_active_balance' | null

  const ConsumeCreditResult({
    required this.success,
    required this.creditsRemaining,
    required this.isUnlimited,
    this.error,
  });
}

/// Consome 1 crédito para uma ação do usuário.
///
/// [actionType] — identificador da ação, ex: 'service_created'
/// [referenceId] — ID do recurso criado (opcional), ex: ID do serviço
///
/// Retorna [ConsumeCreditResult] com o resultado:
/// - success=true: crédito debitado (ou plano ilimitado)
/// - success=false + error='insufficient_credits': sem saldo
/// - success=false + error='no_active_balance': sem assinatura ativa
Future<dynamic> consumeCredit(
  String actionType,
  String? referenceId, {
  http.Client? client,
  Object? authToken = _unset,
}) async {
  try {
    final token = authToken == _unset
        ? SupaFlow.client.auth.currentSession?.accessToken
        : authToken as String?;
    if (token == null) {
      return {
        'success': false,
        'error': 'unauthenticated',
        'creditsRemaining': 0,
        'isUnlimited': false,
      };
    }

    final url = Uri.parse(
        'https://ejnzgjczritznohpdnxl.supabase.co/functions/v1/consume-credit');

    final c = client ?? http.Client();
    try {
      final response = await c.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'actionType': actionType,
          if (referenceId != null) 'referenceId': referenceId,
          'cost': 1,
        }),
      );

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        final data = jsonResponse['data'];
        return {
          'success': true,
          'creditsRemaining': data['creditsRemaining'] ?? 0,
          'isUnlimited': data['isUnlimited'] ?? false,
          'error': null,
        };
      }

      // HTTP 402 — créditos insuficientes ou sem balanço
      if (response.statusCode == 402) {
        return {
          'success': false,
          'error': jsonResponse['error'] ?? 'insufficient_credits',
          'creditsRemaining': jsonResponse['creditsRemaining'] ?? 0,
          'isUnlimited': false,
        };
      }

      // Outros erros
      return {
        'success': false,
        'error': jsonResponse['error'] ?? 'unknown_error',
        'creditsRemaining': 0,
        'isUnlimited': false,
      };
    } finally {
      if (client == null) c.close();
    }
  } catch (e) {
    debugPrint('consumeCredit error: $e');
    return {
      'success': false,
      'error': 'exception',
      'creditsRemaining': 0,
      'isUnlimited': false,
    };
  }
}
