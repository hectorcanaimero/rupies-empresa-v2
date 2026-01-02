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

Future<dynamic> cancelSubscription(
  String subscriptionId,
  bool immediate,
  String? reason,
) async {
  try {
    print('🚫 Cancelando assinatura...');
    print('   Subscription ID: $subscriptionId');
    print('   Immediate: $immediate');
    print('   Reason: ${reason ?? "Não informado"}');

    // Obter token JWT do usuário atual
    final session = await SupaFlow.client.auth.currentSession;
    if (session == null) {
      print('❌ No hay sesión activa');
      return {'success': false, 'error': 'Usuário não autenticado'};
    }

    final token = session.accessToken;

    // URL da Edge Function
    final url = Uri.parse(
        'https://supa.rupies.com.br/functions/v1/cancel-subscription');

    // Preparar body da requisição
    final body = jsonEncode({
      'subscriptionId': subscriptionId,
      'immediate': immediate,
      'reason': reason,
    });

    print('📤 Enviando requisição de cancelamento...');

    // Fazer requisição
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    print('📊 Status code: ${response.statusCode}');
    print('📊 Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'] == true) {
        print('✅ Assinatura cancelada com sucesso!');
        if (immediate) {
          print('   Cancelamento imediato - acesso removido agora');
        } else {
          print('   Cancelamento agendado - acesso até o fim do período');
        }
        return jsonResponse['data'];
      } else {
        print('❌ Error en respuesta: ${jsonResponse['error']}');
        return {
          'success': false,
          'error': jsonResponse['error'] ?? 'Erro desconhecido'
        };
      }
    } else {
      print('❌ Error HTTP: ${response.statusCode}');
      print('❌ Body: ${response.body}');

      try {
        final errorResponse = jsonDecode(response.body);
        return {
          'success': false,
          'error': errorResponse['error'] ?? 'Erro ao cancelar assinatura'
        };
      } catch (e) {
        return {'success': false, 'error': 'Erro ao cancelar assinatura'};
      }
    }
  } catch (e) {
    print('❌ Exception em cancelSubscription: $e');
    return {'success': false, 'error': 'Erro: $e'};
  }
}
