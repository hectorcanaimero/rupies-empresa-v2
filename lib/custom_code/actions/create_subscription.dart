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

import 'package:http/http.dart' as http;

Future<dynamic> createSubscription(
  String planId,
  String billingCycle,
  String paymentMethod,
) async {
  try {
    print('🚀 Criando assinatura...');
    print('   Plan ID: $planId');
    print('   Billing Cycle: $billingCycle');
    print('   Payment Method: $paymentMethod');
    // Obter token JWT do usuário atual
    final supabase = await SupaFlow.client;

    // 🚀 Llamada correcta a Edge Function
    final res = await supabase.functions.invoke(
      'create-asaas-subscription',
      body: {
        'planId': planId,
        'billingCycle': billingCycle,
        'paymentMethod': paymentMethod,
      },
    );

    if (res.data == null) {
      return {
        'success': false,
        'error': 'Resposta vazia da Edge Function',
      };
    }

    return res.data;
  } catch (e) {
    print('❌ Exception em createSubscription: $e');
    return {'success': false, 'error': 'Erro: $e'};
  }
}
