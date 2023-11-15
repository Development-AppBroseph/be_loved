import 'package:be_loved/features/profile/domain/entities/back_file_entity.dart';
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class BackEntity extends Equatable {
  final int? relationId;
  int assetPhoto;
  int? backPhoto;
  final List<BackFileEntity> photos;

  BackEntity({
    required this.assetPhoto,
    required this.backPhoto,
    required this.relationId,
    required this.photos,
  });

  @override
  List<Object> get props => [];
}
