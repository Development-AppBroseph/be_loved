import 'package:equatable/equatable.dart';

class GalleryFileEntity extends Equatable {
  final int id;
  final String urlToFile;
  final String place;
  final DateTime dateTime;
  final int size;

  GalleryFileEntity({
    required this.id,
    required this.urlToFile,
    required this.place,
    required this.dateTime,
    required this.size,
  });


  Map<String, dynamic> toMap() {
    return {
      'place': place,
      'date': dateTime.toString(),
    };
  }
  @override
  List<Object> get props => [
    id,
  ];
}
