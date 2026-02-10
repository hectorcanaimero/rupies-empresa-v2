import '../database.dart';

class SettingsTable extends SupabaseTable<SettingsRow> {
  @override
  String get tableName => 'settings';

  @override
  SettingsRow createRow(Map<String, dynamic> data) => SettingsRow(data);
}

class SettingsRow extends SupabaseDataRow {
  SettingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SettingsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  bool? get active => getField<bool>('active');
  set active(bool? value) => setField<bool>('active', value);

  int? get device => getField<int>('device');
  set device(int? value) => setField<int>('device', value);
}
