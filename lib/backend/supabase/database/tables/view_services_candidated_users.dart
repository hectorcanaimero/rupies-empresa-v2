import '../database.dart';

class ViewServicesCandidatedUsersTable
    extends SupabaseTable<ViewServicesCandidatedUsersRow> {
  @override
  String get tableName => 'view_services_candidated_users';

  @override
  ViewServicesCandidatedUsersRow createRow(Map<String, dynamic> data) =>
      ViewServicesCandidatedUsersRow(data);
}

class ViewServicesCandidatedUsersRow extends SupabaseDataRow {
  ViewServicesCandidatedUsersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ViewServicesCandidatedUsersTable();

  String? get serviceCandidatedId => getField<String>('service_candidated_id');
  set serviceCandidatedId(String? value) =>
      setField<String>('service_candidated_id', value);

  String? get userid => getField<String>('userid');
  set userid(String? value) => setField<String>('userid', value);

  bool? get aproved => getField<bool>('aproved');
  set aproved(bool? value) => setField<bool>('aproved', value);

  DateTime? get publicado => getField<DateTime>('publicado');
  set publicado(DateTime? value) => setField<DateTime>('publicado', value);

  String? get scdescription => getField<String>('scdescription');
  set scdescription(String? value) => setField<String>('scdescription', value);

  String? get displayName => getField<String>('display_name');
  set displayName(String? value) => setField<String>('display_name', value);

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

  String? get latLng => getField<String>('latLng');
  set latLng(String? value) => setField<String>('latLng', value);
}
