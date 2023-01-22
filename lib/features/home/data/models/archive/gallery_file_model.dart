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
    required int? widgetId,
    required bool isVideo,
    required bool isFavorite,

  }) : super(
    id: id, 
    place: place,
    size: size,
    dateTime: dateTime,
    urlToFile: urlToFile,
    isVideo: isVideo,
    isFavorite: isFavorite,
    urlToPreviewVideoImage: urlToPreviewVideoImage,
    duration: duration,
    widgetId: widgetId
  );

  factory GalleryFileModel.fromJson(Map<String, dynamic> json) {
    return GalleryFileModel(
      id: json['id'],
      size: json['size'],
      isVideo: checkIsVideo((json['file'] as String)),
      urlToFile: json['file'],
      place: json['place'] == 'undefined' ? null : json['place'],
      isFavorite: json['if_favor'] ?? false,
      duration: json['duration'],
      urlToPreviewVideoImage: json['image'],
      widgetId: json['widget_id'],
      dateTime: DateTime.parse(json['date']).toLocal(),
    );
  }
}