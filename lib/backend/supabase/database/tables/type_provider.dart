import '../database.dart';

class TypeProviderTable extends SupabaseTable<TypeProviderRow> {
  @override
  String get tableName => 'type_provider';

  @override
  TypeProviderRow createRow(Map<String, dynamic> data) => TypeProviderRow(data);
}

class TypeProviderRow extends SupabaseDataRow {
  TypeProviderRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TypeProviderTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get icon => getField<String>('icon');
  set icon(String? value) => setField<String>('icon', value);

  String? get banner => getField<String>('banner');
  set banner(String? value) => setField<String>('banner', value);

  int? get order => getField<int>('order');
  set order(int? value) => setField<int>('order', value);

  String? get url => getField<String>('url');
  set url(String? value) => setField<String>('url', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  String? get legado => getField<String>('legado');
  set legado(String? value) => setField<String>('legado', value);
}
