import '../database.dart';

class BannersTable extends SupabaseTable<BannersRow> {
  @override
  String get tableName => 'banners';

  @override
  BannersRow createRow(Map<String, dynamic> data) => BannersRow(data);
}

class BannersRow extends SupabaseDataRow {
  BannersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BannersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);

  String? get url => getField<String>('url');
  set url(String? value) => setField<String>('url', value);

  DateTime? get dateStart => getField<DateTime>('dateStart');
  set dateStart(DateTime? value) => setField<DateTime>('dateStart', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  int? get position => getField<int>('position');
  set position(int? value) => setField<int>('position', value);

  DateTime? get dateEnd => getField<DateTime>('dateEnd');
  set dateEnd(DateTime? value) => setField<DateTime>('dateEnd', value);

  List<String> get device => getListField<String>('device');
  set device(List<String>? value) => setListField<String>('device', value);
}
