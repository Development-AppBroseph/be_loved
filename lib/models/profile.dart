import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
  Profile({
    required this.username,
    required this.phoneNumber,
    required this.photo,
  });

  String username;
  String phoneNumber;
  String photo;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
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
