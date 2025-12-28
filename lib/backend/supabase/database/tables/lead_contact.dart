import '../database.dart';

class LeadContactTable extends SupabaseTable<LeadContactRow> {
  @override
  String get tableName => 'lead_contact';

  @override
  LeadContactRow createRow(Map<String, dynamic> data) => LeadContactRow(data);
}

class LeadContactRow extends SupabaseDataRow {
  LeadContactRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LeadContactTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get message => getField<String>('message');
  set message(String? value) => setField<String>('message', value);

  String? get leadId => getField<String>('leadId');
  set leadId(String? value) => setField<String>('leadId', value);

  String? get userId => getField<String>('userId');
  set userId(String? value) => setField<String>('userId', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  bool? get sendEmail => getField<bool>('sendEmail');
  set sendEmail(bool? value) => setField<bool>('sendEmail', value);
}
