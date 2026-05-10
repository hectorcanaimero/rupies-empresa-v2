import '../database.dart';

class CreditBalancesTable extends SupabaseTable<CreditBalancesRow> {
  @override
  String get tableName => 'credit_balances';

  @override
  CreditBalancesRow createRow(Map<String, dynamic> data) =>
      CreditBalancesRow(data);
}

class CreditBalancesRow extends SupabaseDataRow {
  CreditBalancesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CreditBalancesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get subscriptionId => getField<String>('subscription_id');
  set subscriptionId(String? value) =>
      setField<String>('subscription_id', value);

  DateTime get periodStart => getField<DateTime>('period_start')!;
  set periodStart(DateTime value) => setField<DateTime>('period_start', value);

  DateTime get periodEnd => getField<DateTime>('period_end')!;
  set periodEnd(DateTime value) => setField<DateTime>('period_end', value);

  int get creditsGranted => getField<int>('credits_granted')!;
  set creditsGranted(int value) => setField<int>('credits_granted', value);

  int? get creditsUsed => getField<int>('credits_used');
  set creditsUsed(int? value) => setField<int>('credits_used', value);

  int? get creditsRemaining => getField<int>('credits_remaining');
  set creditsRemaining(int? value) =>
      setField<int>('credits_remaining', value);

  bool? get isUnlimited => getField<bool>('is_unlimited');
  set isUnlimited(bool? value) => setField<bool>('is_unlimited', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
