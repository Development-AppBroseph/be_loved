import 'package:be_loved/features/profile/domain/entities/subscription_entiti.dart';

class SubModel extends SubEntiti {
  SubModel({required final bool haveSub})
      : super(
          haveSub: haveSub,
        );

  factory SubModel.fromJson(Map<String, dynamic> json) => SubModel(
        haveSub: json['status'] ?? false,
      );
  Map<String, dynamic> toJson() => {
        'status': haveSub,
      };
}
