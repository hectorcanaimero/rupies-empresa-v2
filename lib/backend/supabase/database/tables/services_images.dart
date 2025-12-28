import '../database.dart';

class ServicesImagesTable extends SupabaseTable<ServicesImagesRow> {
  @override
  String get tableName => 'services_images';

  @override
  ServicesImagesRow createRow(Map<String, dynamic> data) =>
      ServicesImagesRow(data);
}

class ServicesImagesRow extends SupabaseDataRow {
  ServicesImagesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ServicesImagesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get serviceId => getField<String>('serviceId');
  set serviceId(String? value) => setField<String>('serviceId', value);

  String? get image => getField<String>('image');
  set image(String? value) => setField<String>('image', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get leadId => getField<String>('lead_id');
  set leadId(String? value) => setField<String>('lead_id', value);
}
