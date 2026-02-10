import '../database.dart';

class ViewServicesWithCategoriesFilteredExcludeTable
    extends SupabaseTable<ViewServicesWithCategoriesFilteredExcludeRow> {
  @override
  String get tableName => 'view_services_with_categories_filtered_exclude';

  @override
  ViewServicesWithCategoriesFilteredExcludeRow createRow(
          Map<String, dynamic> data) =>
      ViewServicesWithCategoriesFilteredExcludeRow(data);
}

class ViewServicesWithCategoriesFilteredExcludeRow extends SupabaseDataRow {
  ViewServicesWithCategoriesFilteredExcludeRow(Map<String, dynamic> data)
      : super(data);

  @override
  SupabaseTable get table => ViewServicesWithCategoriesFilteredExcludeTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get userId => getField<String>('userId');
  set userId(String? value) => setField<String>('userId', value);

  String? get userAproved => getField<String>('userAproved');
  set userAproved(String? value) => setField<String>('userAproved', value);

  String? get categoryId => getField<String>('categoryId');
  set categoryId(String? value) => setField<String>('categoryId', value);

  String? get jobType => getField<String>('jobType');
  set jobType(String? value) => setField<String>('jobType', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  DateTime? get dateStart => getField<DateTime>('dateStart');
  set dateStart(DateTime? value) => setField<DateTime>('dateStart', value);

  DateTime? get dateEnd => getField<DateTime>('dateEnd');
  set dateEnd(DateTime? value) => setField<DateTime>('dateEnd', value);

  String? get skill => getField<String>('skill');
  set skill(String? value) => setField<String>('skill', value);

  String? get cep => getField<String>('cep');
  set cep(String? value) => setField<String>('cep', value);

  String? get address => getField<String>('address');
  set address(String? value) => setField<String>('address', value);

  double? get price => getField<double>('price');
  set price(double? value) => setField<double>('price', value);

  String? get time => getField<String>('time');
  set time(String? value) => setField<String>('time', value);

  String? get condition => getField<String>('condition');
  set condition(String? value) => setField<String>('condition', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  int? get candidated => getField<int>('candidated');
  set candidated(int? value) => setField<int>('candidated', value);

  bool? get endRegister => getField<bool>('endRegister');
  set endRegister(bool? value) => setField<bool>('endRegister', value);

  String? get categoryName => getField<String>('category_name');
  set categoryName(String? value) => setField<String>('category_name', value);

  List<String> get candidatedIds => getListField<String>('candidated_ids');
  set candidatedIds(List<String>? value) =>
      setListField<String>('candidated_ids', value);
}
