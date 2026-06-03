import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/widgets/nav_bar_widget/nav_bar_widget_widget.dart';
import '/widgets/user_widget/user_widget_widget.dart';
import '/index.dart';
import 'menu_page_widget.dart' show MenuPageWidget;
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MenuPageModel extends FlutterFlowModel<MenuPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for UserWidget component.
  late UserWidgetModel userWidgetModel;
  // Model for navBarWidget component.
  late NavBarWidgetModel navBarWidgetModel;

  // Cached future — initialized once in initState to avoid re-fetching on rebuild.
  late final Future<List<SettingsRow>> subscriptionSettingFuture;
  late final Future<PackageInfo> packageInfoFuture;

  @override
  void initState(BuildContext context) {
    userWidgetModel = createModel(context, () => UserWidgetModel());
    navBarWidgetModel = createModel(context, () => NavBarWidgetModel());
    subscriptionSettingFuture = SettingsTable().querySingleRow(
      queryFn: (q) => q.eqOrNull('type', 'subscription'),
    );
    packageInfoFuture = PackageInfo.fromPlatform();
  }

  @override
  void dispose() {
    userWidgetModel.dispose();
    navBarWidgetModel.dispose();
  }
}
