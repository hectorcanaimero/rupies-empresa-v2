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

Future<bool> checkSubscription(
  String? featureKey, {
  Future<dynamic> Function()? getStatusFn,
}) async {
  try {
    // Obter status completo da subscription
    final status = await (getStatusFn ?? getSubscriptionStatus)();

    if (status == null) {
      debugPrint('❌ Status é null');
      return false;
    }

    // Verificar se tem assinatura ativa
    final hasActiveSubscription = status['hasActiveSubscription'] ?? false;

    if (!hasActiveSubscription) {
      debugPrint('ℹ️  Não tem assinatura ativa');
      return false;
    }

    // Se não especificou feature, retorna true (tem assinatura)
    if (featureKey == null || featureKey.isEmpty) {
      return true;
    }

    // Verificar feature específica
    final features = status['features'] as List<dynamic>? ?? [];
    final hasFeature = features.contains(featureKey);

    debugPrint(hasFeature
        ? '✅ Tem feature: $featureKey'
        : '❌ Não tem feature: $featureKey');

    return hasFeature;
  } catch (e) {
    debugPrint('❌ Exception em checkSubscription: $e');
    return false;
  }
}
