import 'package:be_loved/features/home/domain/entities/purposes/promos_entiti.dart';

class PromosModel extends PromosEntiti {
  PromosModel({
    required final int id,
    required final String shortName,
    required final String name,
    required final String description,
    required final String promo,
    required final String photo,
    required final DateTime? dateEnd,
    required final bool availableWithoutSub,
  }) : super(
          id: id,
          shortName: shortName,
          name: name,
          description: description,
          promo: promo,
          photo: photo,
          dateEnd: dateEnd,
          availableWithoutSub: availableWithoutSub,
        );
  factory PromosModel.fromJson(Map<String, dynamic> json) => PromosModel(
        id: json["id"],
        shortName: json["short_name"] ?? '',
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        promo: json["promo"] ?? '',
        photo: json["photo"] ?? '',
        dateEnd: DateTime.parse(json["date_end"] ?? '2023-03-31'),
        availableWithoutSub: json["available_without_sub"] ?? false,
      );
}
