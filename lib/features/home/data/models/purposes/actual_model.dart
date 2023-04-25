import 'package:be_loved/features/home/domain/entities/purposes/actual_entiti.dart';

class ActualModel extends ActualEntiti {
  ActualModel(
      {required final int id,
      required final PromoDetailsEntiti promoDetailsEntiti})
      : super(
          id: id,
          promoDetailsEntiti: promoDetailsEntiti,
        );
  factory ActualModel.fromJson(Map<String, dynamic> json) => ActualModel(
        id: json['id'],
        promoDetailsEntiti: PromoDetailsModel.fromJson(json['promo_detail']),
      );
}

class PromoDetailsModel extends PromoDetailsEntiti {
  PromoDetailsModel({
    required final int id,
    required final String name,
    required final String discription,
    required final String photo,
    required final DateTime? dateEnd,
  }) : super(
          id: id,
          name: name,
          discription: discription,
          photo: photo,
          dateEnd: dateEnd,
        );
  factory PromoDetailsModel.fromJson(Map<String, dynamic> json) =>
      PromoDetailsModel(
        id: json['id'],
        name: json['name'],
        discription: json[' discription'] ?? '',
        photo: json['photo'],
        dateEnd: DateTime.parse(json['dateEnd'] ?? '2023-04-30').toLocal(),
      );
}
