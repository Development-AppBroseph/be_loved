import 'package:be_loved/core/domain/interface/general_ressponse_body.dart';
import 'package:data_source/callback_result/callback_result.dart';
import 'package:data_source/dto/dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'single_response_body.g.dart';

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
final class SingleResponseBody<T extends DTO> extends GeneralResponseBody<T> {
  SingleResponseBody({
    super.message,
    super.data,
    super.success,
    super.errors,
  });

  factory SingleResponseBody.fromJson(
          Json json, T Function(Object? json) fromJson) =>
      _$SingleResponseBodyFromJson(json, fromJson);

  @override
  Json toJson() => throw UnimplementedError();
}
