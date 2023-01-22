// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

UserAnswer userFromJson(String str) => UserAnswer.fromJson(json.decode(str));

String userToJson(UserAnswer data) => json.encode(data.toJson());

class UserAnswer {
  UserAnswer({
    required this.me,
    required this.love,
    required this.relationId,
    required this.status,
    required this.name,
    required this.theme,
    required this.fromYou,
    required this.vkPID,
    required this.date,
  });

  User me;
  User? love;
  int? relationId;
  String? status;
  String? name;
  String? theme;
  int? vkPID;
  bool? fromYou;
  String? date;

  factory UserAnswer.fromJson(Map<String, dynamic> json) => UserAnswer(
        me: User.fromJson(json["me"]),
        love: json["love"] != null ? User.fromJson(json["love"]) : null,
        relationId: json["relation_id"],
        status: json["status"],
        name: json["name"],
        theme: json["theme"],
        fromYou: json["from_you"],
        date: json["date"],
        vkPID: json["vk_pid"]
      );

  Map<String, dynamic> toJson() => {
        "me": me.toJson(),
        "love": love,
        "relation_id": relationId,
        "status": status,
        "date": date,
        "name": name
      };
}

class User {
  User({
    required this.username,
    required this.phoneNumber,
    required this.photo,
  });

  String username;
  String phoneNumber;
  String? photo;

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        phoneNumber: json["phone_number"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "phone_number": phoneNumber,
        "photo": photo,
      };
}
