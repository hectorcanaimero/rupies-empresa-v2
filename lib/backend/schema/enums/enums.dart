import 'package:ff_commons/flutter_flow/enums.dart';
export 'package:ff_commons/flutter_flow/enums.dart';

enum Conditions {
  Openned,
  InProcess,
  Accepted,
  Cancelled,
  Scheduled,
  Finished,
  Closed,
}

enum JobTypes {
  Agendado,
  Urgente,
  Stand,
}

enum TypeMessage {
  text,
  image,
  audio,
}

enum MessageSendType {
  Contractor,
  Prestador,
}

enum TypeProvider {
  first,
  second,
  third,
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (Conditions):
      return Conditions.values.deserialize(value) as T?;
    case (JobTypes):
      return JobTypes.values.deserialize(value) as T?;
    case (TypeMessage):
      return TypeMessage.values.deserialize(value) as T?;
    case (MessageSendType):
      return MessageSendType.values.deserialize(value) as T?;
    case (TypeProvider):
      return TypeProvider.values.deserialize(value) as T?;
    default:
      return null;
  }
}
