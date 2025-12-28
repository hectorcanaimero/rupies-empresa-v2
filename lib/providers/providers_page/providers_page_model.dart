import '/flutter_flow/flutter_flow_util.dart';
import '/widgets/banner_widget/banner_widget_widget.dart';
import '/widgets/nav_bar_widget/nav_bar_widget_widget.dart';
import '/widgets/user_widget/user_widget_widget.dart';
import '/index.dart';
import 'providers_page_widget.dart' show ProvidersPageWidget;
import 'package:flutter/material.dart';

class ProvidersPageModel extends FlutterFlowModel<ProvidersPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for UserWidget component.
  late UserWidgetModel userWidgetModel;
  // Model for BannerWidget component.
  late BannerWidgetModel bannerWidgetModel;
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
    bannerWidgetModel = createModel(context, () => BannerWidgetModel());
    navBarWidgetModel = createModel(context, () => NavBarWidgetModel());
  }

  @override
  void dispose() {
    userWidgetModel.dispose();
    bannerWidgetModel.dispose();
    tabBarController?.dispose();
    navBarWidgetModel.dispose();
  }
}
