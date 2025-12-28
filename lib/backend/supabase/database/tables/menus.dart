import '../database.dart';

class MenusTable extends SupabaseTable<MenusRow> {
  @override
  String get tableName => 'menus';

  @override
  MenusRow createRow(Map<String, dynamic> data) => MenusRow(data);
}

class MenusRow extends SupabaseDataRow {
  MenusRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MenusTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);

  String? get url => getField<String>('url');
  set url(String? value) => setField<String>('url', value);

  bool? get internal => getField<bool>('internal');
  set internal(bool? value) => setField<bool>('internal', value);

  int? get order => getField<int>('order');
  set order(int? value) => setField<int>('order', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  bool? get active => getField<bool>('active');
  set active(bool? value) => setField<bool>('active', value);
}
