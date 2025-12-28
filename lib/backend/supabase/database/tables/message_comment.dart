import '../database.dart';

class MessageCommentTable extends SupabaseTable<MessageCommentRow> {
  @override
  String get tableName => 'message_comment';

  @override
  MessageCommentRow createRow(Map<String, dynamic> data) =>
      MessageCommentRow(data);
}

class MessageCommentRow extends SupabaseDataRow {
  MessageCommentRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MessageCommentTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  bool? get isContractor => getField<bool>('isContractor');
  set isContractor(bool? value) => setField<bool>('isContractor', value);

  bool? get isBad => getField<bool>('isBad');
  set isBad(bool? value) => setField<bool>('isBad', value);

  int? get order => getField<int>('order');
  set order(int? value) => setField<int>('order', value);
}
