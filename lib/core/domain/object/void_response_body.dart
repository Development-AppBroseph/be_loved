import 'package:data_source/callback_result/misc/typedef_list.dart';
import 'package:json_annotation/json_annotation.dart';

import '../interface/general_ressponse_body.dart';

part 'void_response_body.g.dart';

@JsonSerializable(createToJson: false)
final class VoidResponseBody extends GeneralResponseBody<void> {
  @override
  @JsonKey(includeFromJson: false)
  // ignore: overridden_fields
  void data;

  VoidResponseBody({
    super.success,
    super.message,
    this.data,
    super.errors,
  });

  factory VoidResponseBody.fromJson(Map<String, dynamic> json) =>
      _$VoidResponseBodyFromJson(json);

  @override
  Json toJson() => throw UnimplementedError();
}
