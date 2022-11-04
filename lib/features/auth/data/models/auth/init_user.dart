// To parse this JSON data, do
//
//     final initUserAnswer = initUserAnswerFromJson(jsonString);

import 'dart:convert';

InitUserAnswer initUserAnswerFromJson(String str) =>
    InitUserAnswer.fromJson(json.decode(str));

String initUserAnswerToJson(InitUserAnswer data) => json.encode(data.toJson());

class InitUserAnswer {
  InitUserAnswer({
    required this.authToken,
  });

  String authToken;

  factory InitUserAnswer.fromJson(Map<String, dynamic> json) => InitUserAnswer(
        authToken: json["auth_token"],
      );

  Map<String, dynamic> toJson() => {
        "auth_token": authToken,
      };
}
