// === TEMPLATE: lib/pages/[snake_name]/[snake_name]_widget.dart ===
// Replace [SnakeName] / [PascalName] / [camelName] consistently.
//
// Filename:    settings_page_widget.dart
// PascalName:  SettingsPage          → class is SettingsPageWidget / SettingsPageModel
// camelName:   settingsPage          → URL path
//
// You MUST also create the matching `[snake_name]_model.dart` (see page_model_template.dart).

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:ff_theme/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'settings_page_model.dart';
export 'settings_page_model.dart';

class SettingsPageWidget extends StatefulWidget {
  const SettingsPageWidget({super.key});

  static String routeName = 'SettingsPage'; // PascalCase — used by context.goNamed
  static String routePath = 'settingsPage'; // camelCase — URL path

  @override
  State<SettingsPageWidget> createState() => _SettingsPageWidgetState();
}

class _SettingsPageWidgetState extends State<SettingsPageWidget> {
  late SettingsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingsPageModel());

    logFirebaseEvent('screen_view', parameters: {'screen_name': 'SettingsPage'});
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>(); // re-build on global state changes

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: const [],
          ),
        ),
      ),
    );
  }
}
