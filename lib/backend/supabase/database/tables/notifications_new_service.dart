import '../database.dart';

class NotificationsNewServiceTable
    extends SupabaseTable<NotificationsNewServiceRow> {
  @override
  String get tableName => 'notifications_new_service';

  @override
  NotificationsNewServiceRow createRow(Map<String, dynamic> data) =>
      NotificationsNewServiceRow(data);
}

class NotificationsNewServiceRow extends SupabaseDataRow {
  NotificationsNewServiceRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => NotificationsNewServiceTable();

  int get id => getField<int>('id')!;
  set id(int value) => setField<int>('id', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String get body => getField<String>('body')!;
  set body(String value) => setField<String>('body', value);

  String get categoriesId => getField<String>('categories_id')!;
  set categoriesId(String value) => setField<String>('categories_id', value);

  bool get isRead => getField<bool>('is_read')!;
  set isRead(bool value) => setField<bool>('is_read', value);

  String? get serviceId => getField<String>('service_id');
  set serviceId(String? value) => setField<String>('service_id', value);
}
