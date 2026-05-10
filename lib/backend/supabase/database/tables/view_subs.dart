import '../database.dart';

class ViewSubsTable extends SupabaseTable<ViewSubsRow> {
  @override
  String get tableName => 'view_subs';

  @override
  ViewSubsRow createRow(Map<String, dynamic> data) => ViewSubsRow(data);
}

class ViewSubsRow extends SupabaseDataRow {
  ViewSubsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewSubsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get planId => getField<String>('plan_id');
  set planId(String? value) => setField<String>('plan_id', value);

  String? get asaasSubscriptionId => getField<String>('asaas_subscription_id');
  set asaasSubscriptionId(String? value) =>
      setField<String>('asaas_subscription_id', value);

  String? get asaasCustomerId => getField<String>('asaas_customer_id');
  set asaasCustomerId(String? value) =>
      setField<String>('asaas_customer_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get billingCycle => getField<String>('billing_cycle');
  set billingCycle(String? value) => setField<String>('billing_cycle', value);

  DateTime? get currentPeriodStart =>
      getField<DateTime>('current_period_start');
  set currentPeriodStart(DateTime? value) =>
      setField<DateTime>('current_period_start', value);

  DateTime? get currentPeriodEnd => getField<DateTime>('current_period_end');
  set currentPeriodEnd(DateTime? value) =>
      setField<DateTime>('current_period_end', value);

  bool? get cancelAtPeriodEnd => getField<bool>('cancel_at_period_end');
  set cancelAtPeriodEnd(bool? value) =>
      setField<bool>('cancel_at_period_end', value);

  DateTime? get canceledAt => getField<DateTime>('canceled_at');
  set canceledAt(DateTime? value) => setField<DateTime>('canceled_at', value);

  DateTime? get trialStart => getField<DateTime>('trial_start');
  set trialStart(DateTime? value) => setField<DateTime>('trial_start', value);

  DateTime? get trialEnd => getField<DateTime>('trial_end');
  set trialEnd(DateTime? value) => setField<DateTime>('trial_end', value);

  dynamic get metadata => getField<dynamic>('metadata');
  set metadata(dynamic value) => setField<dynamic>('metadata', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get asaasPaymentLinkId => getField<String>('asaas_payment_link_id');
  set asaasPaymentLinkId(String? value) =>
      setField<String>('asaas_payment_link_id', value);

  String? get spImage => getField<String>('sp_image');
  set spImage(String? value) => setField<String>('sp_image', value);

  String? get spImage2 => getField<String>('sp_image2');
  set spImage2(String? value) => setField<String>('sp_image2', value);

  String? get spImage3 => getField<String>('sp_image3');
  set spImage3(String? value) => setField<String>('sp_image3', value);

  String? get spDescription => getField<String>('sp_description');
  set spDescription(String? value) => setField<String>('sp_description', value);

  String? get spName => getField<String>('sp_name');
  set spName(String? value) => setField<String>('sp_name', value);

  String? get provider => getField<String>('provider');
  set provider(String? value) => setField<String>('provider', value);

  String? get spPlanType => getField<String>('sp_plan_type');
  set spPlanType(String? value) => setField<String>('sp_plan_type', value);

  int? get spCreditsPerMonth => getField<int>('sp_credits_per_month');
  set spCreditsPerMonth(int? value) =>
      setField<int>('sp_credits_per_month', value);

  bool? get spIsUnlimited => getField<bool>('sp_is_unlimited');
  set spIsUnlimited(bool? value) => setField<bool>('sp_is_unlimited', value);

  bool? get spIsFree => getField<bool>('sp_is_free');
  set spIsFree(bool? value) => setField<bool>('sp_is_free', value);

  int? get spPlanVersion => getField<int>('sp_plan_version');
  set spPlanVersion(int? value) => setField<int>('sp_plan_version', value);

  DateTime? get spFreeTierExpiresAt =>
      getField<DateTime>('sp_free_tier_expires_at');
  set spFreeTierExpiresAt(DateTime? value) =>
      setField<DateTime>('sp_free_tier_expires_at', value);

  int? get creditsRemaining => getField<int>('credits_remaining');
  set creditsRemaining(int? value) =>
      setField<int>('credits_remaining', value);

  int? get creditsGranted => getField<int>('credits_granted');
  set creditsGranted(int? value) => setField<int>('credits_granted', value);

  int? get creditsUsed => getField<int>('credits_used');
  set creditsUsed(int? value) => setField<int>('credits_used', value);

  bool? get cbIsUnlimited => getField<bool>('cb_is_unlimited');
  set cbIsUnlimited(bool? value) => setField<bool>('cb_is_unlimited', value);
}
