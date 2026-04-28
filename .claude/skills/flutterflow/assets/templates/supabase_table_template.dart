// === TEMPLATE: lib/backend/supabase/database/tables/[snake_name].dart ===
// Conventions:
//   - Class names = PascalCase("[snake_name]") + "Table" / "Row"
//   - tableName getter returns the literal Postgres table name
//   - Use getField<T>('col')! for non-null columns
//   - Use getField<T>('col')  for nullable columns (returns T?)
//   - DateTime columns are typed as DateTime — Supabase handles serialization

import '../database.dart';

class FooTable extends SupabaseTable<FooRow> {
  @override
  String get tableName => 'foo';

  @override
  FooRow createRow(Map<String, dynamic> data) => FooRow(data);
}

class FooRow extends SupabaseDataRow {
  FooRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => FooTable();

  // Required column: non-null, ends with `!`
  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  // Optional column: returns T?
  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  // Numeric column
  int? get order => getField<int>('order');
  set order(int? value) => setField<int>('order', value);

  // Boolean
  bool? get active => getField<bool>('active');
  set active(bool? value) => setField<bool>('active', value);

  // Timestamp
  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
