// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:data_source/dto/dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'joker_entity.g.dart';

@JsonSerializable(createFactory: true)
class JokerEntity implements DTO {
  final String? address;

  const JokerEntity({
    this.address,
  });

  factory JokerEntity.fromJson(Map<String, dynamic> json) =>
      _$JokerEntityFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$JokerEntityToJson(this);
}
