import 'package:json_annotation/json_annotation.dart';

import 'package:be_loved/constants/constants.dart';

/// {@template enrolled}
/// Признак вовлечённости карты в 3-D Secure.
/// {@endtemplate}
enum Enrolled {
  /// да
  @JsonValue(JsonValues.y)
  yes,

  /// нет
  @JsonValue(JsonValues.n)
  no,

  /// неизвестно
  @JsonValue(JsonValues.u)
  unknown,
}
