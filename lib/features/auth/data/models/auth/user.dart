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
    required this.noti,
    required this.isSub,
    required this.isTest,
    required this.joker,
    this.testEnd,
    this.subEnd,
    required this.previousReletionId,
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
  bool noti;
  DateTime? testEnd;
  JokerModel? joker;
  DateTime? subEnd;
  bool isSub;
  bool isTest;
  int? previousReletionId;

  factory UserAnswer.fromJson(Map<String, dynamic> json) => UserAnswer(
      me: User.fromJson(json["me"]),
      love: json["love"] != null ? User.fromJson(json["love"]) : null,
      relationId: json["relation_id"],
      status: json["status"],
      name: json["name"],
      theme: json["theme"],
      fromYou: json["from_you"] ?? false,
      date: json["date"],
      vkPID: json["vk_pid"],
      isSub: json["is_sub"] ?? false,
      testEnd: json["test_end"] != null
          ? DateTime.tryParse(
              json["test_end"],
            )
          : null,
      joker: json["joker"] != null ? JokerModel.fromJson(json["joker"]) : null,
      subEnd: json["sub_end"] != null
          ? DateTime.parse(
              json["sub_end"],
            ).toLocal()
          : null,
      isTest: json["is_test"] ?? false,
      noti: json["notification_on"] ?? true,
      previousReletionId: json['previous_relation_id']);

  Map<String, dynamic> toJson() => {
        "me": me.toJson(),
        "love": love,
        "relation_id": relationId,
        "status": status,
        "date": date,
        "name": name,
        "is_sub": isSub,
        "is_test": isTest,
        "notification_on": noti,
        'previous_relation_id': previousReletionId,
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

class JokerModel {
  final String? userName;
  final String? photo;

  JokerModel({required this.userName, required this.photo});

  factory JokerModel.fromJson(Map<String, dynamic> json) {
    return JokerModel(
      userName: json["username"],
      photo: json["photo"],
    );
  }
}

// class VirtualJokerModel {
//   final JokerModel? joker;

//   VirtualJokerModel({required this.joker});

//   factory VirtualJokerModel.fromJson(Map<String, dynamic> json) {
//     return VirtualJokerModel(joker: json['joker']);
//   }
