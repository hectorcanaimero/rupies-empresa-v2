import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'subscription_plans_page_widget.dart' show SubscriptionPlansPageWidget;
import 'package:flutter/material.dart';

class SubscriptionPlansPageModel
    extends FlutterFlowModel<SubscriptionPlansPageWidget> {
  ///  Local state fields for this page.

  String? selectedPlanId;

  String selectedBillingCycle = 'monthly';

  bool isCreating = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getSubscriptionStatus] action in SubscriptionPlansPage widget.
  dynamic getsub;
  // Stores action output result for [Custom Action - createSubscription] action in Button widget.
  dynamic createSubResult;
  // Stores action output result for [Backend Call - Query Rows] action in Button widget.
  List<SubscriptionsRow>? dtaSubs;
  // Stores action output result for [Custom Action - createSubscription] action in Image widget.
  dynamic createSubResult1;
  // Stores action output result for [Backend Call - Query Rows] action in Image widget.
  List<SubscriptionsRow>? dtaSubs1;
  // Stores action output result for [Custom Action - createSubscription] action in Image2 widget.
  dynamic createSubResult2;
  // Stores action output result for [Backend Call - Query Rows] action in Image2 widget.
  List<SubscriptionsRow>? dtaSubs2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
