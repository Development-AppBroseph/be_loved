// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_response_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingleResponseBody<T> _$SingleResponseBodyFromJson<T extends DTO>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    SingleResponseBody<T>(
      message: json['message'] as String?,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      success: json['success'] as bool?,
      errors: (json['errors'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
    );

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);
