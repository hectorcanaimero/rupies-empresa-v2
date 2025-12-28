import '../database.dart';

class ServicesCandidatedTable extends SupabaseTable<ServicesCandidatedRow> {
  @override
  String get tableName => 'services_candidated';

  @override
  ServicesCandidatedRow createRow(Map<String, dynamic> data) =>
      ServicesCandidatedRow(data);
}

class ServicesCandidatedRow extends SupabaseDataRow {
  ServicesCandidatedRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ServicesCandidatedTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get serviceId => getField<String>('serviceId');
  set serviceId(String? value) => setField<String>('serviceId', value);

  String? get userId => getField<String>('userId');
  set userId(String? value) => setField<String>('userId', value);

  bool? get aproved => getField<bool>('aproved');
  set aproved(bool? value) => setField<bool>('aproved', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);
}
