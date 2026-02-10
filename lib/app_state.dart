import 'package:flutter/material.dart';
import 'flutter_flow/request_manager.dart';
import '/backend/schema/structs/index.dart';
import 'backend/supabase/supabase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = FlutterSecureStorage();
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_user') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_user') ?? '{}';
          _user = UserStruct.fromSerializableMap(jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      _serviceId = await secureStorage.getString('ff_serviceId') ?? _serviceId;
    });
    await _safeInitAsync(() async {
      _leadId = await secureStorage.getString('ff_leadId') ?? _leadId;
    });
    await _safeInitAsync(() async {
      _fcmToken = await secureStorage.getString('ff_fcmToken') ?? _fcmToken;
    });
    await _safeInitAsync(() async {
      _typecompany =
          await secureStorage.getString('ff_typecompany') ?? _typecompany;
    });
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_trial') != null) {
        try {
          _trial = jsonDecode(await secureStorage.getString('ff_trial') ?? '');
        } catch (e) {
          print("Can't decode persisted json. Error: $e.");
        }
      }
    });
    await _safeInitAsync(() async {
      if (await secureStorage.read(key: 'ff_subscription') != null) {
        try {
          final serializedData =
              await secureStorage.getString('ff_subscription') ?? '{}';
          _subscription = SubsDataTypeStruct.fromSerializableMap(
              jsonDecode(serializedData));
        } catch (e) {
          print("Can't decode persisted data type. Error: $e.");
        }
      }
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  UserStruct _user = UserStruct();
  UserStruct get user => _user;
  set user(UserStruct value) {
    _user = value;
    secureStorage.setString('ff_user', value.serialize());
  }

  void deleteUser() {
    secureStorage.delete(key: 'ff_user');
  }

  void updateUserStruct(Function(UserStruct) updateFn) {
    updateFn(_user);
    secureStorage.setString('ff_user', _user.serialize());
  }

  String _serviceId = '';
  String get serviceId => _serviceId;
  set serviceId(String value) {
    _serviceId = value;
    secureStorage.setString('ff_serviceId', value);
  }

  void deleteServiceId() {
    secureStorage.delete(key: 'ff_serviceId');
  }

  String _leadId = '';
  String get leadId => _leadId;
  set leadId(String value) {
    _leadId = value;
    secureStorage.setString('ff_leadId', value);
  }

  void deleteLeadId() {
    secureStorage.delete(key: 'ff_leadId');
  }

  String _fcmToken = '';
  String get fcmToken => _fcmToken;
  set fcmToken(String value) {
    _fcmToken = value;
    secureStorage.setString('ff_fcmToken', value);
  }

  void deleteFcmToken() {
    secureStorage.delete(key: 'ff_fcmToken');
  }

  double _propPrice = 0.0;
  double get propPrice => _propPrice;
  set propPrice(double value) {
    _propPrice = value;
  }

  String _typecompany = '';
  String get typecompany => _typecompany;
  set typecompany(String value) {
    _typecompany = value;
    secureStorage.setString('ff_typecompany', value);
  }

  void deleteTypecompany() {
    secureStorage.delete(key: 'ff_typecompany');
  }

  String _prefs = '';
  String get prefs => _prefs;
  set prefs(String value) {
    _prefs = value;
  }

  String _initialRoute = '';
  String get initialRoute => _initialRoute;
  set initialRoute(String value) {
    _initialRoute = value;
  }

  dynamic _trial;
  dynamic get trial => _trial;
  set trial(dynamic value) {
    _trial = value;
    secureStorage.setString('ff_trial', jsonEncode(value));
  }

  void deleteTrial() {
    secureStorage.delete(key: 'ff_trial');
  }

  SubsDataTypeStruct _subscription = SubsDataTypeStruct();
  SubsDataTypeStruct get subscription => _subscription;
  set subscription(SubsDataTypeStruct value) {
    _subscription = value;
    secureStorage.setString('ff_subscription', value.serialize());
  }

  void deleteSubscription() {
    secureStorage.delete(key: 'ff_subscription');
  }

  void updateSubscriptionStruct(Function(SubsDataTypeStruct) updateFn) {
    updateFn(_subscription);
    secureStorage.setString('ff_subscription', _subscription.serialize());
  }

  final _categoriesManager = FutureRequestManager<List<CategoriesRow>>();
  Future<List<CategoriesRow>> categories({
    String? uniqueQueryKey,
    bool? overrideCache,
    required Future<List<CategoriesRow>> Function() requestFn,
  }) =>
      _categoriesManager.performRequest(
        uniqueQueryKey: uniqueQueryKey,
        overrideCache: overrideCache,
        requestFn: requestFn,
      );
  void clearCategoriesCache() => _categoriesManager.clear();
  void clearCategoriesCacheKey(String? uniqueKey) =>
      _categoriesManager.clearRequest(uniqueKey);
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: ListToCsvConverter().convert([value]));
}
