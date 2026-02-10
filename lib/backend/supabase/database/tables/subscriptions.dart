import '../database.dart';

class SubscriptionsTable extends SupabaseTable<SubscriptionsRow> {
  @override
  String get tableName => 'subscriptions';

  @override
  SubscriptionsRow createRow(Map<String, dynamic> data) =>
      SubscriptionsRow(data);
}

class SubscriptionsRow extends SupabaseDataRow {
  SubscriptionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SubscriptionsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get planId => getField<String>('plan_id')!;
  set planId(String value) => setField<String>('plan_id', value);

  String? get asaasSubscriptionId => getField<String>('asaas_subscription_id');
  set asaasSubscriptionId(String? value) =>
      setField<String>('asaas_subscription_id', value);

  String? get asaasCustomerId => getField<String>('asaas_customer_id');
  set asaasCustomerId(String? value) =>
      setField<String>('asaas_customer_id', value);

  String get status => getField<String>('status')!;
  set status(String value) => setField<String>('status', value);

  String get billingCycle => getField<String>('billing_cycle')!;
  set billingCycle(String value) => setField<String>('billing_cycle', value);

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
}
