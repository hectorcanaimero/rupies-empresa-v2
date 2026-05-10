import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'subscription_plans_page_widget.dart' show SubscriptionPlansPageWidget;
import 'package:flutter/material.dart';

class SubscriptionPlansPageModel
    extends FlutterFlowModel<SubscriptionPlansPageWidget> {
  ///  Local state fields for this page.

  /// Index do plano selecionado no radio group.
  /// 0 = Gratuito, 1 = Ilimitado (Plano 1), 2 = 30 Créditos (Plano 2)
  int selectedPlanIndex = 0;

  String? selectedPlanId;

  bool isCreating = false;

  ///  State fields for stateful widgets in this page.

  Stream<List<ViewSubsRow>>? subscriptionPlansPageSupabaseStream;

  // Stores action output result for [Custom Action - createSubscription]
  dynamic createSubResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
