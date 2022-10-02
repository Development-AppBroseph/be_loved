import 'dart:convert';

CheckIsUserExist checkIsUserExistFromJson(String str) => CheckIsUserExist.fromJson(json.decode(str));

String checkIsUserExistToJson(CheckIsUserExist data) => json.encode(data.toJson());

class CheckIsUserExist {
  CheckIsUserExist({
    required this.token,
  });

  String token;

  factory CheckIsUserExist.fromJson(Map<String, dynamic> json) => CheckIsUserExist(
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
  };
}
