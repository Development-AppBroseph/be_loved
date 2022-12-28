import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';

class PurposeModel extends PurposeEntity{
  PurposeModel({
    required int id,
    required String name,
    required String photo,
    required DateTime? dateTime,
    required bool ifSeason,

  }) : super(
    id: id, 
    dateTime: dateTime,
    name: name,
    ifSeason: ifSeason,
    photo: photo
  );

  factory PurposeModel.fromJson(Map<String, dynamic> json) {
    return PurposeModel(
      id: json['id'],
      photo: json['photo'],
      ifSeason: json['if_season'] ?? false,
      name: json['name'],
      dateTime: json['time'] == null ? null : DateTime.parse(json['time']).toLocal(),
    );
  }
}