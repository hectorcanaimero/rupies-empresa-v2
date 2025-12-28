import '../database.dart';

class UsersRrssTable extends SupabaseTable<UsersRrssRow> {
  @override
  String get tableName => 'users_rrss';

  @override
  UsersRrssRow createRow(Map<String, dynamic> data) => UsersRrssRow(data);
}

class UsersRrssRow extends SupabaseDataRow {
  UsersRrssRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UsersRrssTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get url => getField<String>('url');
  set url(String? value) => setField<String>('url', value);

  String? get usersId => getField<String>('usersId');
  set usersId(String? value) => setField<String>('usersId', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
