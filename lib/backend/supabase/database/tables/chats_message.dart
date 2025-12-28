import '../database.dart';

class ChatsMessageTable extends SupabaseTable<ChatsMessageRow> {
  @override
  String get tableName => 'chats_message';

  @override
  ChatsMessageRow createRow(Map<String, dynamic> data) => ChatsMessageRow(data);
}

class ChatsMessageRow extends SupabaseDataRow {
  ChatsMessageRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ChatsMessageTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get chatId => getField<String>('chatId');
  set chatId(String? value) => setField<String>('chatId', value);

  String? get content => getField<String>('content');
  set content(String? value) => setField<String>('content', value);

  String? get sendType => getField<String>('sendType');
  set sendType(String? value) => setField<String>('sendType', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get typeMessage => getField<String>('typeMessage');
  set typeMessage(String? value) => setField<String>('typeMessage', value);

  bool? get readMessage => getField<bool>('readMessage');
  set readMessage(bool? value) => setField<bool>('readMessage', value);
}
