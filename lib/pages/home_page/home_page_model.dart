import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/widgets/banner_widget/banner_widget_widget.dart';
import '/widgets/card_accepted_widget/card_accepted_widget_widget.dart';
import '/widgets/card_openned_in_process_widget/card_openned_in_process_widget_widget.dart';
import '/widgets/menu_vertical_widget/menu_vertical_widget_widget.dart';
import '/widgets/nav_bar_widget/nav_bar_widget_widget.dart';
import '/widgets/user_widget/user_widget_widget.dart';
import '/index.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in HomePage widget.
  List<UsersRow>? profile;
  // Model for UserWidget component.
  late UserWidgetModel userWidgetModel;
  // Model for BannerWidget component.
  late BannerWidgetModel bannerWidgetModel;
  // Model for MenuVerticalWidget component.
  late MenuVerticalWidgetModel menuVerticalWidgetModel;
  // Models for CardAcceptedWidget dynamic component.
  late FlutterFlowDynamicModels<CardAcceptedWidgetModel>
      cardAcceptedWidgetModels;
  // Models for CardOpennedInProcessWidget dynamic component.
  late FlutterFlowDynamicModels<CardOpennedInProcessWidgetModel>
      cardOpennedInProcessWidgetModels;
  // Model for navBarWidget component.
  late NavBarWidgetModel navBarWidgetModel;

  @override
  void initState(BuildContext context) {
    userWidgetModel = createModel(context, () => UserWidgetModel());
    bannerWidgetModel = createModel(context, () => BannerWidgetModel());
    menuVerticalWidgetModel =
        createModel(context, () => MenuVerticalWidgetModel());
    cardAcceptedWidgetModels =
        FlutterFlowDynamicModels(() => CardAcceptedWidgetModel());
    cardOpennedInProcessWidgetModels =
        FlutterFlowDynamicModels(() => CardOpennedInProcessWidgetModel());
    navBarWidgetModel = createModel(context, () => NavBarWidgetModel());
  }

  @override
  void dispose() {
    userWidgetModel.dispose();
    bannerWidgetModel.dispose();
    menuVerticalWidgetModel.dispose();
    cardAcceptedWidgetModels.dispose();
    cardOpennedInProcessWidgetModels.dispose();
    navBarWidgetModel.dispose();
  }
}
