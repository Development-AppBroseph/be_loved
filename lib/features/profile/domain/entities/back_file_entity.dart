import 'package:equatable/equatable.dart';

class BackFileEntity extends Equatable {
  final int id;
  final String file;

  BackFileEntity({
    required this.id,
    required this.file,
  });


  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'file': file
    };
  }


  @override
  List<Object> get props => [
        id,
        file
      ];
}
