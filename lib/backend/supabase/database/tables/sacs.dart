import '../database.dart';

class SacsTable extends SupabaseTable<SacsRow> {
  @override
  String get tableName => 'sacs';

  @override
  SacsRow createRow(Map<String, dynamic> data) => SacsRow(data);
}

class SacsRow extends SupabaseDataRow {
  SacsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SacsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get user => getField<String>('user');
  set user(String? value) => setField<String>('user', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get message => getField<String>('message');
  set message(String? value) => setField<String>('message', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
