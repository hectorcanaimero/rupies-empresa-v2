import '../database.dart';

class UsersSkillTable extends SupabaseTable<UsersSkillRow> {
  @override
  String get tableName => 'users_skill';

  @override
  UsersSkillRow createRow(Map<String, dynamic> data) => UsersSkillRow(data);
}

class UsersSkillRow extends SupabaseDataRow {
  UsersSkillRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UsersSkillTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('userId');
  set userId(String? value) => setField<String>('userId', value);

  String? get categoryId => getField<String>('categoryId');
  set categoryId(String? value) => setField<String>('categoryId', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
