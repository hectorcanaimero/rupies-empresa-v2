import '../database.dart';

class ViewSubscriptionMetricsTable
    extends SupabaseTable<ViewSubscriptionMetricsRow> {
  @override
  String get tableName => 'view_subscription_metrics';

  @override
  ViewSubscriptionMetricsRow createRow(Map<String, dynamic> data) =>
      ViewSubscriptionMetricsRow(data);
}

class ViewSubscriptionMetricsRow extends SupabaseDataRow {
  ViewSubscriptionMetricsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewSubscriptionMetricsTable();

  int? get totalActive => getField<int>('total_active');
  set totalActive(int? value) => setField<int>('total_active', value);

  int? get totalTrialing => getField<int>('total_trialing');
  set totalTrialing(int? value) => setField<int>('total_trialing', value);

  int? get totalPastDue => getField<int>('total_past_due');
  set totalPastDue(int? value) => setField<int>('total_past_due', value);

  int? get totalCanceled => getField<int>('total_canceled');
  set totalCanceled(int? value) => setField<int>('total_canceled', value);

  int? get totalPending => getField<int>('total_pending');
  set totalPending(int? value) => setField<int>('total_pending', value);

  double? get mrr => getField<double>('mrr');
  set mrr(double? value) => setField<double>('mrr', value);

  double? get arr => getField<double>('arr');
  set arr(double? value) => setField<double>('arr', value);

  int? get monthlySubscriptions => getField<int>('monthly_subscriptions');
  set monthlySubscriptions(int? value) =>
      setField<int>('monthly_subscriptions', value);

  int? get yearlySubscriptions => getField<int>('yearly_subscriptions');
  set yearlySubscriptions(int? value) =>
      setField<int>('yearly_subscriptions', value);

  int? get pendingCancellations => getField<int>('pending_cancellations');
  set pendingCancellations(int? value) =>
      setField<int>('pending_cancellations', value);

  int? get canceledLast30Days => getField<int>('canceled_last_30_days');
  set canceledLast30Days(int? value) =>
      setField<int>('canceled_last_30_days', value);

  int? get activeTrials => getField<int>('active_trials');
  set activeTrials(int? value) => setField<int>('active_trials', value);

  int? get expiredTrials => getField<int>('expired_trials');
  set expiredTrials(int? value) => setField<int>('expired_trials', value);
}
