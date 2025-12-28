import '../database.dart';

class ServicesSkillsTable extends SupabaseTable<ServicesSkillsRow> {
  @override
  String get tableName => 'services_skills';

  @override
  ServicesSkillsRow createRow(Map<String, dynamic> data) =>
      ServicesSkillsRow(data);
}

class ServicesSkillsRow extends SupabaseDataRow {
  ServicesSkillsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ServicesSkillsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get serviceId => getField<String>('serviceId');
  set serviceId(String? value) => setField<String>('serviceId', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
