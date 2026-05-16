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

/// Verifica se o usuário tem plano ativo e créditos suficientes para criar
/// um serviço (Urgente, Agendado) ou Lead.
///
/// Exibe um [AlertDialog] explicativo se a validação falhar.
/// Retorna [true] se pode prosseguir, [false] caso contrário.
Future<bool> validatePlanAndCredits(
  BuildContext context, {
  SubsDataTypeStruct? subscriptionOverride,
}) async {
  final sub = subscriptionOverride ?? FFAppState().subscription;
  final isActive = sub.status == 'active';
  final hasCredits = sub.isUnlimited || sub.creditsRemaining > 0;

  if (isActive && hasCredits) return true;

  final String title;
  final String message;

  if (!isActive) {
    title = 'Plano não ativo';
    message =
        'Você precisa de um plano ativo para criar serviços ou leads. '
        'Acesse a área de planos e assine para continuar.';
  } else {
    title = 'Sem créditos';
    message =
        'Você não tem créditos suficientes para criar este serviço ou lead. '
        'Faça upgrade do seu plano ou aguarde o próximo ciclo de faturamento.';
  }

  await showDialog<void>(
    context: context,
    builder: (alertDialogContext) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(alertDialogContext),
            child: const Text('Fechar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(alertDialogContext);
              if (context.mounted) {
                context.goNamed('SubscriptionPlansPage');
              }
            },
            child: const Text('Ver planos'),
          ),
        ],
      );
    },
  );

  return false;
}
