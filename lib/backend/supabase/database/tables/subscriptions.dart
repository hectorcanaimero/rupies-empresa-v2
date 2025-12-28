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

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  double? get priceBase => getField<double>('price_base');
  set priceBase(double? value) => setField<double>('price_base', value);

  double? get priceDiscount => getField<double>('price_discount');
  set priceDiscount(double? value) => setField<double>('price_discount', value);

  bool? get active => getField<bool>('active');
  set active(bool? value) => setField<bool>('active', value);
}
