import '../database.dart';

class ViewChurnedSubscriptionsTable
    extends SupabaseTable<ViewChurnedSubscriptionsRow> {
  @override
  String get tableName => 'view_churned_subscriptions';

  @override
  ViewChurnedSubscriptionsRow createRow(Map<String, dynamic> data) =>
      ViewChurnedSubscriptionsRow(data);
}

class ViewChurnedSubscriptionsRow extends SupabaseDataRow {
  ViewChurnedSubscriptionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewChurnedSubscriptionsTable();

  String? get subscriptionId => getField<String>('subscription_id');
  set subscriptionId(String? value) =>
      setField<String>('subscription_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get userEmail => getField<String>('user_email');
  set userEmail(String? value) => setField<String>('user_email', value);

  String? get userName => getField<String>('user_name');
  set userName(String? value) => setField<String>('user_name', value);

  String? get planName => getField<String>('plan_name');
  set planName(String? value) => setField<String>('plan_name', value);

  String? get billingCycle => getField<String>('billing_cycle');
  set billingCycle(String? value) => setField<String>('billing_cycle', value);

  DateTime? get subscriptionStarted =>
      getField<DateTime>('subscription_started');
  set subscriptionStarted(DateTime? value) =>
      setField<DateTime>('subscription_started', value);

  DateTime? get canceledAt => getField<DateTime>('canceled_at');
  set canceledAt(DateTime? value) => setField<DateTime>('canceled_at', value);

  DateTime? get subscriptionEnded => getField<DateTime>('subscription_ended');
  set subscriptionEnded(DateTime? value) =>
      setField<DateTime>('subscription_ended', value);

  double? get daysSubscribed => getField<double>('days_subscribed');
  set daysSubscribed(double? value) =>
      setField<double>('days_subscribed', value);

  double? get estimatedLtv => getField<double>('estimated_ltv');
  set estimatedLtv(double? value) => setField<double>('estimated_ltv', value);

  String? get cancellationReason => getField<String>('cancellation_reason');
  set cancellationReason(String? value) =>
      setField<String>('cancellation_reason', value);

  String? get cancellationFeedback => getField<String>('cancellation_feedback');
  set cancellationFeedback(String? value) =>
      setField<String>('cancellation_feedback', value);
}
