import 'package:be_loved/features/home/domain/entities/purposes/promos_entiti.dart';
import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';

import 'promos_model.dart';

class PurposeModel extends PurposeEntity {
  PurposeModel({
    required int id,
    required int? widgetId,
    required String name,
    required String photo,
    required String? verdict,
    required int? forPhotoId,
    required DateTime? dateTime,
    required bool ifSeason,
    required bool inHistory,
    required PromosModel? promo,
  }) : super(
            id: id,
            dateTime: dateTime,
            name: name,
            ifSeason: ifSeason,
            photo: photo,
            inHistory: inHistory,
            verdict: verdict,
            forPhotoId: forPhotoId,
            widgetId: widgetId,
            promo: promo);

  factory PurposeModel.fromJson(Map<String, dynamic> json) {
    return PurposeModel(
      id: json['id'],
      photo: json['photo'],
      ifSeason: json['if_season'] ?? false,
      name: json['name'],
      verdict: json['verdict'],
      forPhotoId: json['answer_id'],
      widgetId: json['widget_id'],
      inHistory: json['verdict'] == 'Принято' ? true : false,
      dateTime:
          json['time'] == null ? null : DateTime.parse(json['time']).toLocal(),
      promo: json['promo'] == null ? null : PromosModel.fromJson(json['promo']),
    );
  }
}
