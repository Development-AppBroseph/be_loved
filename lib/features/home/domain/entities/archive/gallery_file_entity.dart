import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

// ignore: must_be_immutable
class GalleryFileEntity extends Equatable {
  final int id;
  final String urlToFile;
  final String? place;
  final DateTime dateTime;
  final int size;
  final bool isVideo;
  bool isFavorite;
  Uint8List? memoryFilePhotoForVideo;
  final String? urlToPreviewVideoImage;
  final int? duration;
  final int? widgetId;
  final String? targetName;

  GalleryFileEntity({
    required this.id,
    required this.urlToFile,
    required this.place,
    required this.dateTime,
    required this.size,
    required this.isFavorite,
    required this.isVideo,
    this.memoryFilePhotoForVideo,
    required this.duration,
    required this.urlToPreviewVideoImage,
    required this.widgetId,
    this.targetName,
  });

  Future<Map<String, dynamic>> toMap() async {
    return {
      'place': place,
      'file': await MultipartFile.fromFile(urlToFile),
      'date': dateTime.toString(),
    };
  }

  @override
  List<Object> get props => [
        id,
      ];
}
