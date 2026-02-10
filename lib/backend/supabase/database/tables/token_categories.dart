import '../database.dart';

class TokenCategoriesTable extends SupabaseTable<TokenCategoriesRow> {
  @override
  String get tableName => 'token_categories';

  @override
  TokenCategoriesRow createRow(Map<String, dynamic> data) =>
      TokenCategoriesRow(data);
}

class TokenCategoriesRow extends SupabaseDataRow {
  TokenCategoriesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TokenCategoriesTable();

  String? get categoryId => getField<String>('categoryId');
  set categoryId(String? value) => setField<String>('categoryId', value);

  String? get fcmToken => getField<String>('fcm_token');
  set fcmToken(String? value) => setField<String>('fcm_token', value);
}
