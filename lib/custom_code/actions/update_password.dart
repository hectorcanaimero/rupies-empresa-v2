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

import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> updatePassword(String newPassword) async {
  // Add your function code here!
  try {
    final supabase = SupaFlow.client;

    final response = await supabase.auth.updateUser(
      UserAttributes(
        password: newPassword,
      ),
    );

    if (response.user == null) {
      return false;
    }

    return true;
  } catch (e) {
    // Log opcional si usás Crashlytics o similar
    debugPrint('Error updating password: $e');
    return false;
  }
}
