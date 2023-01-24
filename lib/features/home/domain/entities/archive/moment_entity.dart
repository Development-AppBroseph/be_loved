import 'package:be_loved/features/home/domain/entities/archive/album_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:equatable/equatable.dart';

class MomentEntity extends Equatable {
  final List<GalleryFileEntity> forYou;
  List<GalleryFileEntity> otherFiles;
  List<AlbumEntity> groupedOtherFiles;

  MomentEntity({
    required this.forYou,
    required this.otherFiles,
    required this.groupedOtherFiles,
  });


  @override
  List<Object> get props => [
    forYou,
    otherFiles,
    groupedOtherFiles
  ];
}
