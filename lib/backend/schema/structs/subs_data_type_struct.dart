// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SubsDataTypeStruct extends BaseStruct {
  SubsDataTypeStruct({
    String? id,
    String? asaasSubscriptionId,
    String? status,
    DateTime? currentPeriodStart,
    String? billingCycle,
    DateTime? currentPeriodEnd,
    String? typePlan,
    String? planId,
  })  : _id = id,
        _asaasSubscriptionId = asaasSubscriptionId,
        _status = status,
        _currentPeriodStart = currentPeriodStart,
        _billingCycle = billingCycle,
        _currentPeriodEnd = currentPeriodEnd,
        _typePlan = typePlan,
        _planId = planId;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "asaasSubscriptionId" field.
  String? _asaasSubscriptionId;
  String get asaasSubscriptionId => _asaasSubscriptionId ?? '';
  set asaasSubscriptionId(String? val) => _asaasSubscriptionId = val;

  bool hasAsaasSubscriptionId() => _asaasSubscriptionId != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "currentPeriodStart" field.
  DateTime? _currentPeriodStart;
  DateTime? get currentPeriodStart => _currentPeriodStart;
  set currentPeriodStart(DateTime? val) => _currentPeriodStart = val;

  bool hasCurrentPeriodStart() => _currentPeriodStart != null;

  // "billingCycle" field.
  String? _billingCycle;
  String get billingCycle => _billingCycle ?? '';
  set billingCycle(String? val) => _billingCycle = val;

  bool hasBillingCycle() => _billingCycle != null;

  // "currentPeriodEnd" field.
  DateTime? _currentPeriodEnd;
  DateTime? get currentPeriodEnd => _currentPeriodEnd;
  set currentPeriodEnd(DateTime? val) => _currentPeriodEnd = val;

  bool hasCurrentPeriodEnd() => _currentPeriodEnd != null;

  // "typePlan" field.
  String? _typePlan;
  String get typePlan => _typePlan ?? '';
  set typePlan(String? val) => _typePlan = val;

  bool hasTypePlan() => _typePlan != null;

  // "planId" field.
  String? _planId;
  String get planId => _planId ?? '';
  set planId(String? val) => _planId = val;

  bool hasPlanId() => _planId != null;

  static SubsDataTypeStruct fromMap(Map<String, dynamic> data) =>
      SubsDataTypeStruct(
        id: data['id'] as String?,
        asaasSubscriptionId: data['asaasSubscriptionId'] as String?,
        status: data['status'] as String?,
        currentPeriodStart: data['currentPeriodStart'] as DateTime?,
        billingCycle: data['billingCycle'] as String?,
        currentPeriodEnd: data['currentPeriodEnd'] as DateTime?,
        typePlan: data['typePlan'] as String?,
        planId: data['planId'] as String?,
      );

  static SubsDataTypeStruct? maybeFromMap(dynamic data) => data is Map
      ? SubsDataTypeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'asaasSubscriptionId': _asaasSubscriptionId,
        'status': _status,
        'currentPeriodStart': _currentPeriodStart,
        'billingCycle': _billingCycle,
        'currentPeriodEnd': _currentPeriodEnd,
        'typePlan': _typePlan,
        'planId': _planId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'asaasSubscriptionId': serializeParam(
          _asaasSubscriptionId,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'currentPeriodStart': serializeParam(
          _currentPeriodStart,
          ParamType.DateTime,
        ),
        'billingCycle': serializeParam(
          _billingCycle,
          ParamType.String,
        ),
        'currentPeriodEnd': serializeParam(
          _currentPeriodEnd,
          ParamType.DateTime,
        ),
        'typePlan': serializeParam(
          _typePlan,
          ParamType.String,
        ),
        'planId': serializeParam(
          _planId,
          ParamType.String,
        ),
      }.withoutNulls;

  static SubsDataTypeStruct fromSerializableMap(Map<String, dynamic> data) =>
      SubsDataTypeStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        asaasSubscriptionId: deserializeParam(
          data['asaasSubscriptionId'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        currentPeriodStart: deserializeParam(
          data['currentPeriodStart'],
          ParamType.DateTime,
          false,
        ),
        billingCycle: deserializeParam(
          data['billingCycle'],
          ParamType.String,
          false,
        ),
        currentPeriodEnd: deserializeParam(
          data['currentPeriodEnd'],
          ParamType.DateTime,
          false,
        ),
        typePlan: deserializeParam(
          data['typePlan'],
          ParamType.String,
          false,
        ),
        planId: deserializeParam(
          data['planId'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SubsDataTypeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SubsDataTypeStruct &&
        id == other.id &&
        asaasSubscriptionId == other.asaasSubscriptionId &&
        status == other.status &&
        currentPeriodStart == other.currentPeriodStart &&
        billingCycle == other.billingCycle &&
        currentPeriodEnd == other.currentPeriodEnd &&
        typePlan == other.typePlan &&
        planId == other.planId;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        asaasSubscriptionId,
        status,
        currentPeriodStart,
        billingCycle,
        currentPeriodEnd,
        typePlan,
        planId
      ]);
}

SubsDataTypeStruct createSubsDataTypeStruct({
  String? id,
  String? asaasSubscriptionId,
  String? status,
  DateTime? currentPeriodStart,
  String? billingCycle,
  DateTime? currentPeriodEnd,
  String? typePlan,
  String? planId,
}) =>
    SubsDataTypeStruct(
      id: id,
      asaasSubscriptionId: asaasSubscriptionId,
      status: status,
      currentPeriodStart: currentPeriodStart,
      billingCycle: billingCycle,
      currentPeriodEnd: currentPeriodEnd,
      typePlan: typePlan,
      planId: planId,
    );
