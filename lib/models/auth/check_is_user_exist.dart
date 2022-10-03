import 'dart:convert';

CheckIsUserExist checkIsUserExistFromJson(String str) =>
    CheckIsUserExist.fromJson(json.decode(str));

String checkIsUserExistToJson(CheckIsUserExist data) =>
    json.encode(data.toJson());

class CheckIsUserExist {
  CheckIsUserExist({
    required this.token,
    required this.secretKey,
  });

  String? token;
  String? secretKey;

  factory CheckIsUserExist.fromJson(Map<String, dynamic> json) =>
      CheckIsUserExist(
        token: json["token"],
        secretKey: json["secret_key"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "secret_key": secretKey,
      };
}
