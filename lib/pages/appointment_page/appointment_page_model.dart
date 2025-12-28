import '/flutter_flow/flutter_flow_util.dart';
import '/widgets/card_accepted_widget/card_accepted_widget_widget.dart';
import '/widgets/card_openned_in_process_widget/card_openned_in_process_widget_widget.dart';
import '/widgets/nav_bar_widget/nav_bar_widget_widget.dart';
import '/widgets/user_widget/user_widget_widget.dart';
import '/index.dart';
import 'appointment_page_widget.dart' show AppointmentPageWidget;
import 'package:flutter/material.dart';

class AppointmentPageModel extends FlutterFlowModel<AppointmentPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for UserWidget component.
  late UserWidgetModel userWidgetModel;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Models for CardOpennedInProcessWidget dynamic component.
  late FlutterFlowDynamicModels<CardOpennedInProcessWidgetModel>
      cardOpennedInProcessWidgetModels;
  // Models for CardAcceptedWidget dynamic component.
  late FlutterFlowDynamicModels<CardAcceptedWidgetModel>
      cardAcceptedWidgetModels;
  // Model for navBarWidget component.
  late NavBarWidgetModel navBarWidgetModel;

  @override
  void initState(BuildContext context) {
    userWidgetModel = createModel(context, () => UserWidgetModel());
    cardOpennedInProcessWidgetModels =
        FlutterFlowDynamicModels(() => CardOpennedInProcessWidgetModel());
    cardAcceptedWidgetModels =
        FlutterFlowDynamicModels(() => CardAcceptedWidgetModel());
    navBarWidgetModel = createModel(context, () => NavBarWidgetModel());
  }

  @override
  void dispose() {
    userWidgetModel.dispose();
    tabBarController?.dispose();
    cardOpennedInProcessWidgetModels.dispose();
    cardAcceptedWidgetModels.dispose();
    navBarWidgetModel.dispose();
  }
}
