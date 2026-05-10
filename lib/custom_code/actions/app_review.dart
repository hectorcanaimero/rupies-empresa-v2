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

import 'dart:io'; // Para verificar o sistema operacional
import 'package:rate_my_app/rate_my_app.dart';

Future appReview(BuildContext context) async {
  // Executar apenas em dispositivos compatíveis
  if (Platform.isAndroid || Platform.isIOS) {
    RateMyApp rateMyApp = RateMyApp(
      minDays: 7, // Mínimo de dias antes de solicitar uma avaliação
      minLaunches:
          5, // Mínimo de inicializações antes de solicitar uma avaliação
      remindDays: 7, // Dias para lembrar o usuário após a primeira solicitação
      remindLaunches:
          10, // Inicializações para lembrar após a primeira solicitação
      googlePlayIdentifier: 'com.rupies.companies',
      appStoreIdentifier: '6751551463',
    );

    // Inicializar e verificar condições
    await rateMyApp.init();
    if (rateMyApp.shouldOpenDialog) {
      rateMyApp.showRateDialog(
        // O contexto deve ser passado se você estiver usando isso no Flutter
        context,
        title: 'Você está gostando do nosso aplicativo?',
        message: 'Adoraríamos que você deixasse uma avaliação!',
        rateButton: 'Avaliar agora',
        noButton: 'Não, obrigado',
        laterButton: 'Lembrar mais tarde',
        listener: (button) {
          switch (button) {
            case RateMyAppDialogButton.rate:
              debugPrint('O usuário escolheu avaliar o app.');
              break;
            case RateMyAppDialogButton.later:
              debugPrint('O usuário escolheu lembrar mais tarde.');
              break;
            case RateMyAppDialogButton.no:
              debugPrint('O usuário não quer avaliar o app.');
              break;
          }
          return true; // Fechar a caixa de diálogo
        },
      );
    }
  } else {
    debugPrint('Função de avaliação não suportada nesta plataforma.');
  }
}
