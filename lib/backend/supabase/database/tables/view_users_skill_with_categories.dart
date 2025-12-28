import '../database.dart';

class ViewUsersSkillWithCategoriesTable
    extends SupabaseTable<ViewUsersSkillWithCategoriesRow> {
  @override
  String get tableName => 'view_users_skill_with_categories';

  @override
  ViewUsersSkillWithCategoriesRow createRow(Map<String, dynamic> data) =>
      ViewUsersSkillWithCategoriesRow(data);
}

class ViewUsersSkillWithCategoriesRow extends SupabaseDataRow {
  ViewUsersSkillWithCategoriesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewUsersSkillWithCategoriesTable();

  String? get usersSkillId => getField<String>('users_skill_id');
  set usersSkillId(String? value) => setField<String>('users_skill_id', value);

  String? get userId => getField<String>('userId');
  set userId(String? value) => setField<String>('userId', value);

  String? get categoryId => getField<String>('categoryId');
  set categoryId(String? value) => setField<String>('categoryId', value);

  DateTime? get usersSkillCreatedAt =>
      getField<DateTime>('users_skill_created_at');
  set usersSkillCreatedAt(DateTime? value) =>
      setField<DateTime>('users_skill_created_at', value);

  String? get categoryName => getField<String>('category_name');
  set categoryName(String? value) => setField<String>('category_name', value);
}
