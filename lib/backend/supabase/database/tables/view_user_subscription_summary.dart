import '../database.dart';

class ViewUserSubscriptionSummaryTable
    extends SupabaseTable<ViewUserSubscriptionSummaryRow> {
  @override
  String get tableName => 'view_user_subscription_summary';

  @override
  ViewUserSubscriptionSummaryRow createRow(Map<String, dynamic> data) =>
      ViewUserSubscriptionSummaryRow(data);
}

class ViewUserSubscriptionSummaryRow extends SupabaseDataRow {
  ViewUserSubscriptionSummaryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewUserSubscriptionSummaryTable();

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get displayName => getField<String>('display_name');
  set displayName(String? value) => setField<String>('display_name', value);

  String? get subscriptionId => getField<String>('subscription_id');
  set subscriptionId(String? value) =>
      setField<String>('subscription_id', value);

  String? get subscriptionStatus => getField<String>('subscription_status');
  set subscriptionStatus(String? value) =>
      setField<String>('subscription_status', value);

  String? get planName => getField<String>('plan_name');
  set planName(String? value) => setField<String>('plan_name', value);

  dynamic get features => getField<dynamic>('features');
  set features(dynamic value) => setField<dynamic>('features', value);

  int? get maxServicesPerMonth => getField<int>('max_services_per_month');
  set maxServicesPerMonth(int? value) =>
      setField<int>('max_services_per_month', value);

  int? get maxContractorsContacted =>
      getField<int>('max_contractors_contacted');
  set maxContractorsContacted(int? value) =>
      setField<int>('max_contractors_contacted', value);

  int? get servicesUsedThisMonth => getField<int>('services_used_this_month');
  set servicesUsedThisMonth(int? value) =>
      setField<int>('services_used_this_month', value);

  int? get contractorsContactedThisMonth =>
      getField<int>('contractors_contacted_this_month');
  set contractorsContactedThisMonth(int? value) =>
      setField<int>('contractors_contacted_this_month', value);

  int? get servicesRemaining => getField<int>('services_remaining');
  set servicesRemaining(int? value) =>
      setField<int>('services_remaining', value);

  int? get contactsRemaining => getField<int>('contacts_remaining');
  set contactsRemaining(int? value) =>
      setField<int>('contacts_remaining', value);

  bool? get prioritySupport => getField<bool>('priority_support');
  set prioritySupport(bool? value) => setField<bool>('priority_support', value);

  bool? get featuredListing => getField<bool>('featured_listing');
  set featuredListing(bool? value) => setField<bool>('featured_listing', value);

  bool? get analyticsDashboard => getField<bool>('analytics_dashboard');
  set analyticsDashboard(bool? value) =>
      setField<bool>('analytics_dashboard', value);

  DateTime? get currentPeriodStart =>
      getField<DateTime>('current_period_start');
  set currentPeriodStart(DateTime? value) =>
      setField<DateTime>('current_period_start', value);

  DateTime? get currentPeriodEnd => getField<DateTime>('current_period_end');
  set currentPeriodEnd(DateTime? value) =>
      setField<DateTime>('current_period_end', value);

  DateTime? get trialEnd => getField<DateTime>('trial_end');
  set trialEnd(DateTime? value) => setField<DateTime>('trial_end', value);

  bool? get cancelAtPeriodEnd => getField<bool>('cancel_at_period_end');
  set cancelAtPeriodEnd(bool? value) =>
      setField<bool>('cancel_at_period_end', value);

  bool? get isPremium => getField<bool>('is_premium');
  set isPremium(bool? value) => setField<bool>('is_premium', value);

  bool? get isTrial => getField<bool>('is_trial');
  set isTrial(bool? value) => setField<bool>('is_trial', value);

  bool? get paymentFailed => getField<bool>('payment_failed');
  set paymentFailed(bool? value) => setField<bool>('payment_failed', value);
}
