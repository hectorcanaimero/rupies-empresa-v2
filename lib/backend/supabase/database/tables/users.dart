import '../database.dart';

class UsersTable extends SupabaseTable<UsersRow> {
  @override
  String get tableName => 'users';

  @override
  UsersRow createRow(Map<String, dynamic> data) => UsersRow(data);
}

class UsersRow extends SupabaseDataRow {
  UsersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UsersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get displayName => getField<String>('display_name');
  set displayName(String? value) => setField<String>('display_name', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  String? get portfolioId => getField<String>('portfolioId');
  set portfolioId(String? value) => setField<String>('portfolioId', value);

  String? get rrssId => getField<String>('rrssId');
  set rrssId(String? value) => setField<String>('rrssId', value);

  bool? get isContractor => getField<bool>('isContractor');
  set isContractor(bool? value) => setField<bool>('isContractor', value);

  String? get address => getField<String>('address');
  set address(String? value) => setField<String>('address', value);

  String? get cep => getField<String>('cep');
  set cep(String? value) => setField<String>('cep', value);

  String? get cpfcnpj => getField<String>('cpfcnpj');
  set cpfcnpj(String? value) => setField<String>('cpfcnpj', value);

  bool? get status => getField<bool>('status');
  set status(bool? value) => setField<bool>('status', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get push => getField<String>('push');
  set push(String? value) => setField<String>('push', value);

  bool? get endRegister => getField<bool>('endRegister');
  set endRegister(bool? value) => setField<bool>('endRegister', value);

  String? get photoUrl => getField<String>('photo_url');
  set photoUrl(String? value) => setField<String>('photo_url', value);

  String? get nameContractor => getField<String>('name_contractor');
  set nameContractor(String? value) =>
      setField<String>('name_contractor', value);

  double? get rating => getField<double>('rating');
  set rating(double? value) => setField<double>('rating', value);

  String? get state => getField<String>('state');
  set state(String? value) => setField<String>('state', value);

  String? get city => getField<String>('city');
  set city(String? value) => setField<String>('city', value);

  String? get latLng => getField<String>('latLng');
  set latLng(String? value) => setField<String>('latLng', value);

  String? get placeName => getField<String>('place_name');
  set placeName(String? value) => setField<String>('place_name', value);

  String? get app => getField<String>('app');
  set app(String? value) => setField<String>('app', value);

  String? get bio => getField<String>('bio');
  set bio(String? value) => setField<String>('bio', value);

  String? get fcmToken => getField<String>('fcm_token');
  set fcmToken(String? value) => setField<String>('fcm_token', value);

  bool? get ban => getField<bool>('ban');
  set ban(bool? value) => setField<bool>('ban', value);

  String? get typeCompany => getField<String>('type_company');
  set typeCompany(String? value) => setField<String>('type_company', value);

  String? get chavePix => getField<String>('chave_pix');
  set chavePix(String? value) => setField<String>('chave_pix', value);

  dynamic get trial => getField<dynamic>('trial');
  set trial(dynamic value) => setField<dynamic>('trial', value);

  List<String> get categoriesId => getListField<String>('categories_id');
  set categoriesId(List<String>? value) =>
      setListField<String>('categories_id', value);

  bool? get termos => getField<bool>('termos');
  set termos(bool? value) => setField<bool>('termos', value);

  bool? get privacidade => getField<bool>('privacidade');
  set privacidade(bool? value) => setField<bool>('privacidade', value);
}
