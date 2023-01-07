import 'package:be_loved/features/home/data/models/archive/gallery_file_model.dart';
import 'package:be_loved/features/home/domain/entities/archive/album_entity.dart';

class AlbumModel extends AlbumEntity{
  AlbumModel({
    required int id,
    required int relationId,
    required String name,
    required List<GalleryFileModel> files,
    required bool isFavorite,

  }) : super(
    id: id, 
    name: name,
    files: files,
    isFavorite: isFavorite,
    relationId: relationId
  );

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      id: json['id'],
      relationId: json['relation'],
      name: json['name'],
      isFavorite: json['if_favor'],
      files: (json['files_detail'] as List).map((jsonE) => GalleryFileModel.fromJson(jsonE)).toList(),
    );
  }
}