class HashTagData {
  String? title;
  TypeHashTag type;

  HashTagData({this.title, required this.type});
}

enum TypeHashTag { main, user, custom, add }
