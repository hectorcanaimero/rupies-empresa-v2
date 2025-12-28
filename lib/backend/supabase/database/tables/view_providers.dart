import '../database.dart';

class ViewProvidersTable extends SupabaseTable<ViewProvidersRow> {
  @override
  String get tableName => 'view_providers';

  @override
  ViewProvidersRow createRow(Map<String, dynamic> data) =>
      ViewProvidersRow(data);
}

class ViewProvidersRow extends SupabaseDataRow {
  ViewProvidersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewProvidersTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get logo => getField<String>('logo');
  set logo(String? value) => setField<String>('logo', value);

  String? get banner => getField<String>('banner');
  set banner(String? value) => setField<String>('banner', value);

  String? get fb => getField<String>('fb');
  set fb(String? value) => setField<String>('fb', value);

  String? get ig => getField<String>('ig');
  set ig(String? value) => setField<String>('ig', value);

  String? get wa => getField<String>('wa');
  set wa(String? value) => setField<String>('wa', value);

  String? get web => getField<String>('web');
  set web(String? value) => setField<String>('web', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  int? get order => getField<int>('order');
  set order(int? value) => setField<int>('order', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get select => getField<String>('select');
  set select(String? value) => setField<String>('select', value);

  String? get nameType => getField<String>('name_type');
  set nameType(String? value) => setField<String>('name_type', value);
}
