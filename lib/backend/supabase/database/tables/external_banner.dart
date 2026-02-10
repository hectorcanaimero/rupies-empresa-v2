import '../database.dart';

class ExternalBannerTable extends SupabaseTable<ExternalBannerRow> {
  @override
  String get tableName => 'external_banner';

  @override
  ExternalBannerRow createRow(Map<String, dynamic> data) =>
      ExternalBannerRow(data);
}

class ExternalBannerRow extends SupabaseDataRow {
  ExternalBannerRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ExternalBannerTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);

  String? get url => getField<String>('url');
  set url(String? value) => setField<String>('url', value);

  String? get textButton => getField<String>('text_button');
  set textButton(String? value) => setField<String>('text_button', value);

  String? get colorButton => getField<String>('color_button');
  set colorButton(String? value) => setField<String>('color_button', value);

  DateTime? get start => getField<DateTime>('start');
  set start(DateTime? value) => setField<DateTime>('start', value);

  DateTime? get end => getField<DateTime>('end');
  set end(DateTime? value) => setField<DateTime>('end', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  int? get order => getField<int>('order');
  set order(int? value) => setField<int>('order', value);

  String? get colorText => getField<String>('color_text');
  set colorText(String? value) => setField<String>('color_text', value);
}
