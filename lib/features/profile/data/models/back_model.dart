import 'package:be_loved/features/profile/data/models/back_file_model.dart';
import 'package:be_loved/features/profile/domain/entities/back_entity.dart';

// ignore: must_be_immutable
class BackModel extends BackEntity {
  BackModel({
    required int? relationId,
    required int assetPhoto,
    required int? backPhoto,
    required List<BackFileModel> photos,
  }) : super(
            relationId: relationId,
            photos: photos,
            assetPhoto: assetPhoto,
            backPhoto: backPhoto);

  factory BackModel.fromJson(Map<String, dynamic> json) {
    return BackModel(
      assetPhoto: json['asset_photo'] ?? 0,
      backPhoto: json['back_photo'] == null ? null : json['back_photo']['id'],
      relationId: json['relation'],
      photos: json['photos_detail'] != null
          ? (json['photos_detail'] as List)
              .map((json) => BackFileModel.fromJson(json))
              .toList()
          : [],
    );
  }
}
