import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:equatable/equatable.dart';

class AlbumEntity extends Equatable {
  final int id;
  final int relationId;
  final String name;
  final List<GalleryFileEntity> files;

  AlbumEntity({
    required this.id,
    required this.relationId,
    required this.name,
    required this.files,
  });


  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'files': files.map((e) => e.id).toList()
    };
  }
  @override
  List<Object> get props => [
    id,
  ];
}
