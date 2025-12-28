import '/flutter_flow/flutter_flow_util.dart';
import '/widgets/nav_bar_widget/nav_bar_widget_widget.dart';
import '/widgets/user_widget/user_widget_widget.dart';
import '/index.dart';
import 'lead_page_widget.dart' show LeadPageWidget;
import 'package:flutter/material.dart';

class LeadPageModel extends FlutterFlowModel<LeadPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for UserWidget component.
  late UserWidgetModel userWidgetModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Model for navBarWidget component.
  late NavBarWidgetModel navBarWidgetModel;

  @override
  void initState(BuildContext context) {
    userWidgetModel = createModel(context, () => UserWidgetModel());
    navBarWidgetModel = createModel(context, () => NavBarWidgetModel());
  }

  @override
  void dispose() {
    userWidgetModel.dispose();
    tabBarController?.dispose();
    navBarWidgetModel.dispose();
  }
}
