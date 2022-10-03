// To parse this JSON data, do
//
//     final inviteAnswer = inviteAnswerFromJson(jsonString);

import 'dart:convert';

InviteAnswer inviteAnswerFromJson(String str) =>
    InviteAnswer.fromJson(json.decode(str));

String inviteAnswerToJson(InviteAnswer data) => json.encode(data.toJson());

class InviteAnswer {
  InviteAnswer({
    required this.fromUser,
    required this.toUser,
  });

  int fromUser;
  int toUser;

  factory InviteAnswer.fromJson(Map<String, dynamic> json) => InviteAnswer(
        fromUser: json["from_user"],
        toUser: json["to_user"],
      );

  Map<String, dynamic> toJson() => {
        "from_user": fromUser,
        "to_user": toUser,
      };
}
