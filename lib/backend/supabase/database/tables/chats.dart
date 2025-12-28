import '../database.dart';

class ChatsTable extends SupabaseTable<ChatsRow> {
  @override
  String get tableName => 'chats';

  @override
  ChatsRow createRow(Map<String, dynamic> data) => ChatsRow(data);
}

class ChatsRow extends SupabaseDataRow {
  ChatsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ChatsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get serviceId => getField<String>('serviceId');
  set serviceId(String? value) => setField<String>('serviceId', value);

  String? get userId => getField<String>('userId');
  set userId(String? value) => setField<String>('userId', value);

  String? get userCandidate => getField<String>('userCandidate');
  set userCandidate(String? value) => setField<String>('userCandidate', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get leadId => getField<String>('lead_id');
  set leadId(String? value) => setField<String>('lead_id', value);
}
