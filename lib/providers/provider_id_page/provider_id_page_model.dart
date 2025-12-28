import '/flutter_flow/flutter_flow_util.dart';
import '/providers/provider_gold_widget/provider_gold_widget_widget.dart';
import '/providers/provider_premium_widget/provider_premium_widget_widget.dart';
import '/providers/provider_silver_widget/provider_silver_widget_widget.dart';
import 'provider_id_page_widget.dart' show ProviderIdPageWidget;
import 'package:flutter/material.dart';

class ProviderIdPageModel extends FlutterFlowModel<ProviderIdPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for ProviderPremiumWidget dynamic component.
  late FlutterFlowDynamicModels<ProviderPremiumWidgetModel>
      providerPremiumWidgetModels;
  // Models for ProviderGoldWidget dynamic component.
  late FlutterFlowDynamicModels<ProviderGoldWidgetModel>
      providerGoldWidgetModels;
  // Models for ProviderSilverWidget dynamic component.
  late FlutterFlowDynamicModels<ProviderSilverWidgetModel>
      providerSilverWidgetModels;

  @override
  void initState(BuildContext context) {
    providerPremiumWidgetModels =
        FlutterFlowDynamicModels(() => ProviderPremiumWidgetModel());
    providerGoldWidgetModels =
        FlutterFlowDynamicModels(() => ProviderGoldWidgetModel());
    providerSilverWidgetModels =
        FlutterFlowDynamicModels(() => ProviderSilverWidgetModel());
  }

  @override
  void dispose() {
    providerPremiumWidgetModels.dispose();
    providerGoldWidgetModels.dispose();
    providerSilverWidgetModels.dispose();
  }
}
