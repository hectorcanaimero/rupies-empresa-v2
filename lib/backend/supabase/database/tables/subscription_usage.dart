import '../database.dart';

class SubscriptionUsageTable extends SupabaseTable<SubscriptionUsageRow> {
  @override
  String get tableName => 'subscription_usage';

  @override
  SubscriptionUsageRow createRow(Map<String, dynamic> data) =>
      SubscriptionUsageRow(data);
}

class SubscriptionUsageRow extends SupabaseDataRow {
  SubscriptionUsageRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SubscriptionUsageTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get subscriptionId => getField<String>('subscription_id')!;
  set subscriptionId(String value) =>
      setField<String>('subscription_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  DateTime get periodStart => getField<DateTime>('period_start')!;
  set periodStart(DateTime value) => setField<DateTime>('period_start', value);

  DateTime get periodEnd => getField<DateTime>('period_end')!;
  set periodEnd(DateTime value) => setField<DateTime>('period_end', value);

  int? get servicesCreated => getField<int>('services_created');
  set servicesCreated(int? value) => setField<int>('services_created', value);

  int? get contractorsContacted => getField<int>('contractors_contacted');
  set contractorsContacted(int? value) =>
      setField<int>('contractors_contacted', value);

  int? get candidatesReceived => getField<int>('candidates_received');
  set candidatesReceived(int? value) =>
      setField<int>('candidates_received', value);

  dynamic get metadata => getField<dynamic>('metadata');
  set metadata(dynamic value) => setField<dynamic>('metadata', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
