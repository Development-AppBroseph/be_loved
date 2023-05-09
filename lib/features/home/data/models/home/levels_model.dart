import 'package:be_loved/features/home/domain/entities/home/levels_entiti.dart';

class LevelModel extends LevelEntiti {
  LevelModel({
    required final int id,
    required final int years,
    required final String image,
  }) : super(
          id: id,
          years: years,
          image: image,
        );

  factory LevelModel.fromJson(Map<String, dynamic> json) => LevelModel(
        id: json['id'] as int,
        years: json['years'] as int,
        image: json['photo'] as String,
      );
}
