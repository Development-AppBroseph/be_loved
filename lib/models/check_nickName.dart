import 'dart:convert';

CheckNickName checkNickNameFromJson(String str) => CheckNickName.fromJson(json.decode(str));

String checkNickNameToJson(CheckNickName data) => json.encode(data.toJson());

class CheckNickName {
  CheckNickName({
    required this.exists,
  });

  bool exists;

  factory CheckNickName.fromJson(Map<String, dynamic> json) => CheckNickName(
    exists: json["exists"],
  );

  Map<String, dynamic> toJson() => {
    "exists": exists,
  };
}
