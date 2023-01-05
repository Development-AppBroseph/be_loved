import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/presentation/views/archive/helpers/video_helper.dart';

class GalleryFileModel extends GalleryFileEntity{
  GalleryFileModel({
    required int id,
    required String? place,
    required int size,
    required DateTime dateTime,
    required String urlToFile,
    required String? urlToPreviewVideoImage,
    required int? duration,
    required bool isVideo,

  }) : super(
    id: id, 
    place: place,
    size: size,
    dateTime: dateTime,
    urlToFile: urlToFile,
    isVideo: isVideo,
    urlToPreviewVideoImage: urlToPreviewVideoImage,
    duration: duration
  );

  factory GalleryFileModel.fromJson(Map<String, dynamic> json) {
    return GalleryFileModel(
      id: json['id'],
      size: json['size'],
      isVideo: checkIsVideo((json['file'] as String)),
      urlToFile: json['file'],
      place: json['place'] == 'undefined' ? null : json['place'],
      duration: json['duration'],
      urlToPreviewVideoImage: json['image'],
      dateTime: DateTime.parse(json['date']).toLocal(),
    );
  }
}