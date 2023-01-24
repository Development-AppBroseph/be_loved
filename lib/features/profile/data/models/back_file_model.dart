import 'package:be_loved/features/profile/domain/entities/back_file_entity.dart';

class BackFileModel extends BackFileEntity{
  BackFileModel({
    required int id,
    required String file

  }) : super(
    id: id, 
    file: file
  );

  factory BackFileModel.fromJson(Map<String, dynamic> json) {
    return BackFileModel(
      id: json['id'],
      file: json['file'],
    );
  }
}
