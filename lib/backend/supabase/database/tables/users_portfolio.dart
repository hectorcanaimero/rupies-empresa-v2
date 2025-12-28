import '../database.dart';

class UsersPortfolioTable extends SupabaseTable<UsersPortfolioRow> {
  @override
  String get tableName => 'users_portfolio';

  @override
  UsersPortfolioRow createRow(Map<String, dynamic> data) =>
      UsersPortfolioRow(data);
}

class UsersPortfolioRow extends SupabaseDataRow {
  UsersPortfolioRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UsersPortfolioTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get userId => getField<String>('userId');
  set userId(String? value) => setField<String>('userId', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get images => getField<String>('images');
  set images(String? value) => setField<String>('images', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}
