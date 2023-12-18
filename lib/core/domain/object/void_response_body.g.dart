// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'void_response_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoidResponseBody _$VoidResponseBodyFromJson(Map<String, dynamic> json) =>
    VoidResponseBody(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      errors: (json['errors'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ),
    );
