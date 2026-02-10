import '../database.dart';

class ViewActiveSubscriptionsTable
    extends SupabaseTable<ViewActiveSubscriptionsRow> {
  @override
  String get tableName => 'view_active_subscriptions';

  @override
  ViewActiveSubscriptionsRow createRow(Map<String, dynamic> data) =>
      ViewActiveSubscriptionsRow(data);
}

class ViewActiveSubscriptionsRow extends SupabaseDataRow {
  ViewActiveSubscriptionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewActiveSubscriptionsTable();

  String? get subscriptionId => getField<String>('subscription_id');
  set subscriptionId(String? value) =>
      setField<String>('subscription_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get userEmail => getField<String>('user_email');
  set userEmail(String? value) => setField<String>('user_email', value);

  String? get userName => getField<String>('user_name');
  set userName(String? value) => setField<String>('user_name', value);

  String? get nameContractor => getField<String>('name_contractor');
  set nameContractor(String? value) =>
      setField<String>('name_contractor', value);

  String? get cpfcnpj => getField<String>('cpfcnpj');
  set cpfcnpj(String? value) => setField<String>('cpfcnpj', value);

  String? get subscriptionStatus => getField<String>('subscription_status');
  set subscriptionStatus(String? value) =>
      setField<String>('subscription_status', value);

  String? get billingCycle => getField<String>('billing_cycle');
  set billingCycle(String? value) => setField<String>('billing_cycle', value);

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

  DateTime? get canceledAt => getField<DateTime>('canceled_at');
  set canceledAt(DateTime? value) => setField<DateTime>('canceled_at', value);

  DateTime? get subscriptionCreatedAt =>
      getField<DateTime>('subscription_created_at');
  set subscriptionCreatedAt(DateTime? value) =>
      setField<DateTime>('subscription_created_at', value);

  String? get planId => getField<String>('plan_id');
  set planId(String? value) => setField<String>('plan_id', value);

  String? get planName => getField<String>('plan_name');
  set planName(String? value) => setField<String>('plan_name', value);

  double? get priceMonthly => getField<double>('price_monthly');
  set priceMonthly(double? value) => setField<double>('price_monthly', value);

  double? get priceYearly => getField<double>('price_yearly');
  set priceYearly(double? value) => setField<double>('price_yearly', value);

  dynamic get features => getField<dynamic>('features');
  set features(dynamic value) => setField<dynamic>('features', value);

  int? get maxServicesPerMonth => getField<int>('max_services_per_month');
  set maxServicesPerMonth(int? value) =>
      setField<int>('max_services_per_month', value);

  int? get maxContractorsContacted =>
      getField<int>('max_contractors_contacted');
  set maxContractorsContacted(int? value) =>
      setField<int>('max_contractors_contacted', value);

  bool? get prioritySupport => getField<bool>('priority_support');
  set prioritySupport(bool? value) => setField<bool>('priority_support', value);

  bool? get featuredListing => getField<bool>('featured_listing');
  set featuredListing(bool? value) => setField<bool>('featured_listing', value);

  bool? get analyticsDashboard => getField<bool>('analytics_dashboard');
  set analyticsDashboard(bool? value) =>
      setField<bool>('analytics_dashboard', value);

  String? get statusDisplay => getField<String>('status_display');
  set statusDisplay(String? value) => setField<String>('status_display', value);

  DateTime? get expiresAt => getField<DateTime>('expires_at');
  set expiresAt(DateTime? value) => setField<DateTime>('expires_at', value);

  double? get currentPrice => getField<double>('current_price');
  set currentPrice(double? value) => setField<double>('current_price', value);
}
