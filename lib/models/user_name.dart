import 'dart:convert';

UserName userNameFromJson(String str) => UserName.fromJson(json.decode(str));

String userNameToJson(UserName data) => json.encode(data.toJson());

class UserName {
  UserName({
    required this.username,
  });

  String username;

  factory UserName.fromJson(Map<String, dynamic> json) => UserName(
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
  };
}
