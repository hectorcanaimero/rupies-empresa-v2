import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'subscription_plans_page_widget.dart' show SubscriptionPlansPageWidget;
import 'package:flutter/material.dart';

class SubscriptionPlansPageModel
    extends FlutterFlowModel<SubscriptionPlansPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for selected plan
  String? selectedPlanId;
  String? selectedBillingCycle = 'monthly'; // 'monthly' or 'yearly'

  // Store subscription plans from database
  List<SubscriptionPlansRow>? subscriptionPlans;

  // Store current subscription status
  dynamic currentSubscriptionStatus;

  // Loading state
  bool isLoading = true;
  bool isCreatingSubscription = false;

  // Error message
  String? errorMessage;

  @override
  void initState(BuildContext context) {
    // Initialization
  }

  @override
  void dispose() {
    // Cleanup
  }

  /// Action to select a plan
  void selectPlan(String planId) {
    selectedPlanId = planId;
  }

  /// Action to select billing cycle
  void selectBillingCycle(String cycle) {
    selectedBillingCycle = cycle;
  }
}
