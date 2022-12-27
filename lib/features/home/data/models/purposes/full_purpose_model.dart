import 'package:be_loved/features/home/data/models/purposes/purpose_model.dart';
import 'package:be_loved/features/home/domain/entities/purposes/full_purpose_entity.dart';

class FullPurposeModel extends FullPurposeEntity{
  FullPurposeModel({
    required int id,
    required String? verdict,
    required String? desc,
    required String? photo,
    required PurposeModel purpose,

  }) : super(
    id: id, 
    photo: photo,
    verdict: verdict,
    desc: desc,
    purpose: purpose
  );

  factory FullPurposeModel.fromJson(Map<String, dynamic> json) {
    return FullPurposeModel(
      id: json['id'],
      photo: json['photo'],
      verdict: json['verdict'],
      desc: json['desc'],
      purpose: PurposeModel.fromJson(json['target_detail']),
    );
  }
}