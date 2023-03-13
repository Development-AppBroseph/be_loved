import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:equatable/equatable.dart';

class   GalleryGroupFilesEntity extends Equatable {
  GalleryFileEntity mainPhoto;
  GalleryFileEntity? mainVideo;
  DateTime startDate;
  DateTime? toDate;
  List<GalleryFileEntity> additionalFiles;
  double topPosition;

  GalleryGroupFilesEntity({
    required this.mainPhoto,
    required this.mainVideo,
    required this.additionalFiles,
    required this.startDate,
    required this.toDate,
    this.topPosition = 0
  });


  @override
  List<Object> get props => [
    mainPhoto,
    additionalFiles
  ];
}
