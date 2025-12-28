// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserStruct extends BaseStruct {
  UserStruct({
    String? displayName,
    String? phone,
    bool? isContractor,
    String? addres,
    String? cep,
    String? cpfcnpj,
    String? push,
    String? photoUrl,
    bool? endRegister,
    double? rating,
    String? nameContractor,
  })  : _displayName = displayName,
        _phone = phone,
        _isContractor = isContractor,
        _addres = addres,
        _cep = cep,
        _cpfcnpj = cpfcnpj,
        _push = push,
        _photoUrl = photoUrl,
        _endRegister = endRegister,
        _rating = rating,
        _nameContractor = nameContractor;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  set displayName(String? val) => _displayName = val;

  bool hasDisplayName() => _displayName != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  set phone(String? val) => _phone = val;

  bool hasPhone() => _phone != null;

  // "isContractor" field.
  bool? _isContractor;
  bool get isContractor => _isContractor ?? false;
  set isContractor(bool? val) => _isContractor = val;

  bool hasIsContractor() => _isContractor != null;

  // "addres" field.
  String? _addres;
  String get addres => _addres ?? '';
  set addres(String? val) => _addres = val;

  bool hasAddres() => _addres != null;

  // "cep" field.
  String? _cep;
  String get cep => _cep ?? '';
  set cep(String? val) => _cep = val;

  bool hasCep() => _cep != null;

  // "cpfcnpj" field.
  String? _cpfcnpj;
  String get cpfcnpj => _cpfcnpj ?? '';
  set cpfcnpj(String? val) => _cpfcnpj = val;

  bool hasCpfcnpj() => _cpfcnpj != null;

  // "push" field.
  String? _push;
  String get push => _push ?? '';
  set push(String? val) => _push = val;

  bool hasPush() => _push != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  set photoUrl(String? val) => _photoUrl = val;

  bool hasPhotoUrl() => _photoUrl != null;

  // "endRegister" field.
  bool? _endRegister;
  bool get endRegister => _endRegister ?? false;
  set endRegister(bool? val) => _endRegister = val;

  bool hasEndRegister() => _endRegister != null;

  // "rating" field.
  double? _rating;
  double get rating => _rating ?? 0.0;
  set rating(double? val) => _rating = val;

  void incrementRating(double amount) => rating = rating + amount;

  bool hasRating() => _rating != null;

  // "name_contractor" field.
  String? _nameContractor;
  String get nameContractor => _nameContractor ?? '';
  set nameContractor(String? val) => _nameContractor = val;

  bool hasNameContractor() => _nameContractor != null;

  static UserStruct fromMap(Map<String, dynamic> data) => UserStruct(
        displayName: data['display_name'] as String?,
        phone: data['phone'] as String?,
        isContractor: data['isContractor'] as bool?,
        addres: data['addres'] as String?,
        cep: data['cep'] as String?,
        cpfcnpj: data['cpfcnpj'] as String?,
        push: data['push'] as String?,
        photoUrl: data['photo_url'] as String?,
        endRegister: data['endRegister'] as bool?,
        rating: castToType<double>(data['rating']),
        nameContractor: data['name_contractor'] as String?,
      );

  static UserStruct? maybeFromMap(dynamic data) =>
      data is Map ? UserStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'display_name': _displayName,
        'phone': _phone,
        'isContractor': _isContractor,
        'addres': _addres,
        'cep': _cep,
        'cpfcnpj': _cpfcnpj,
        'push': _push,
        'photo_url': _photoUrl,
        'endRegister': _endRegister,
        'rating': _rating,
        'name_contractor': _nameContractor,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'display_name': serializeParam(
          _displayName,
          ParamType.String,
        ),
        'phone': serializeParam(
          _phone,
          ParamType.String,
        ),
        'isContractor': serializeParam(
          _isContractor,
          ParamType.bool,
        ),
        'addres': serializeParam(
          _addres,
          ParamType.String,
        ),
        'cep': serializeParam(
          _cep,
          ParamType.String,
        ),
        'cpfcnpj': serializeParam(
          _cpfcnpj,
          ParamType.String,
        ),
        'push': serializeParam(
          _push,
          ParamType.String,
        ),
        'photo_url': serializeParam(
          _photoUrl,
          ParamType.String,
        ),
        'endRegister': serializeParam(
          _endRegister,
          ParamType.bool,
        ),
        'rating': serializeParam(
          _rating,
          ParamType.double,
        ),
        'name_contractor': serializeParam(
          _nameContractor,
          ParamType.String,
        ),
      }.withoutNulls;

  static UserStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserStruct(
        displayName: deserializeParam(
          data['display_name'],
          ParamType.String,
          false,
        ),
        phone: deserializeParam(
          data['phone'],
          ParamType.String,
          false,
        ),
        isContractor: deserializeParam(
          data['isContractor'],
          ParamType.bool,
          false,
        ),
        addres: deserializeParam(
          data['addres'],
          ParamType.String,
          false,
        ),
        cep: deserializeParam(
          data['cep'],
          ParamType.String,
          false,
        ),
        cpfcnpj: deserializeParam(
          data['cpfcnpj'],
          ParamType.String,
          false,
        ),
        push: deserializeParam(
          data['push'],
          ParamType.String,
          false,
        ),
        photoUrl: deserializeParam(
          data['photo_url'],
          ParamType.String,
          false,
        ),
        endRegister: deserializeParam(
          data['endRegister'],
          ParamType.bool,
          false,
        ),
        rating: deserializeParam(
          data['rating'],
          ParamType.double,
          false,
        ),
        nameContractor: deserializeParam(
          data['name_contractor'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'UserStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserStruct &&
        displayName == other.displayName &&
        phone == other.phone &&
        isContractor == other.isContractor &&
        addres == other.addres &&
        cep == other.cep &&
        cpfcnpj == other.cpfcnpj &&
        push == other.push &&
        photoUrl == other.photoUrl &&
        endRegister == other.endRegister &&
        rating == other.rating &&
        nameContractor == other.nameContractor;
  }

  @override
  int get hashCode => const ListEquality().hash([
        displayName,
        phone,
        isContractor,
        addres,
        cep,
        cpfcnpj,
        push,
        photoUrl,
        endRegister,
        rating,
        nameContractor
      ]);
}

UserStruct createUserStruct({
  String? displayName,
  String? phone,
  bool? isContractor,
  String? addres,
  String? cep,
  String? cpfcnpj,
  String? push,
  String? photoUrl,
  bool? endRegister,
  double? rating,
  String? nameContractor,
}) =>
    UserStruct(
      displayName: displayName,
      phone: phone,
      isContractor: isContractor,
      addres: addres,
      cep: cep,
      cpfcnpj: cpfcnpj,
      push: push,
      photoUrl: photoUrl,
      endRegister: endRegister,
      rating: rating,
      nameContractor: nameContractor,
    );
