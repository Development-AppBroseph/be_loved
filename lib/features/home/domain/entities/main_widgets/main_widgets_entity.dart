import 'package:equatable/equatable.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';

class MainWidgetsEntity extends Equatable {
  GalleryFileEntity? file;
  List<PurposeEntity> purposes;

  MainWidgetsEntity({
    required this.file,
    required this.purposes,
  });

  @override
  List<Object> get props => [
  ];
}
