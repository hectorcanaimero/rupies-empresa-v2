import '../database.dart';

class LeadAttachmentTable extends SupabaseTable<LeadAttachmentRow> {
  @override
  String get tableName => 'lead_attachment';

  @override
  LeadAttachmentRow createRow(Map<String, dynamic> data) =>
      LeadAttachmentRow(data);
}

class LeadAttachmentRow extends SupabaseDataRow {
  LeadAttachmentRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LeadAttachmentTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get leadId => getField<String>('leadId');
  set leadId(String? value) => setField<String>('leadId', value);

  String? get url => getField<String>('url');
  set url(String? value) => setField<String>('url', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);
}
