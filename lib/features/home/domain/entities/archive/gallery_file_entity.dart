import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

class GalleryFileEntity extends Equatable {
  final int id;
  final String urlToFile;
  final String? place;
  final DateTime dateTime;
  final int size;

  GalleryFileEntity({
    required this.id,
    required this.urlToFile,
    required this.place,
    required this.dateTime,
    required this.size,
  });


  Future<Map<String, dynamic>> toMap() async{
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
