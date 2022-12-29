import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';

class GalleryFileModel extends GalleryFileEntity{
  GalleryFileModel({
    required int id,
    required String? place,
    required int size,
    required DateTime dateTime,
    required String urlToFile,

  }) : super(
    id: id, 
    place: place,
    size: size,
    dateTime: dateTime,
    urlToFile: urlToFile
  );

  factory GalleryFileModel.fromJson(Map<String, dynamic> json) {
    return GalleryFileModel(
      id: json['id'],
      size: json['size'],
      urlToFile: json['file'],
      place: json['place'],
      dateTime: DateTime.parse(json['date']).toLocal(),
    );
  }
}