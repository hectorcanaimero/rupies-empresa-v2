// === TEMPLATE: lib/pages/[snake_name]/[snake_name]_model.dart ===
// Goes hand-in-hand with page_widget_template.dart.

import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'settings_page_widget.dart' show SettingsPageWidget;
import 'package:flutter/material.dart';

class SettingsPageModel extends FlutterFlowModel<SettingsPageWidget> {
  /// State fields for stateful widgets in this page.
  // Example: result of a query
  // List<UsersRow>? profile;

  /// Models for child components used in the page.
  // late ChildWidgetModel childWidgetModel;

  /// FlutterFlowDynamicModels for list-rendered components.
  // late FlutterFlowDynamicModels<ChildCardModel> childCardModels;

  @override
  void initState(BuildContext context) {
    // Instantiate every child component model here:
    // childWidgetModel = createModel(context, () => ChildWidgetModel());
    // childCardModels = FlutterFlowDynamicModels(() => ChildCardModel());
  }

  @override
  void dispose() {
    // Dispose every child component model here, in any order:
    // childWidgetModel.dispose();
    // childCardModels.dispose();
  }
}
