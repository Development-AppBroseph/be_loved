import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final int id;
  final String chatName;
  final int usersCount;
  final bool flag;
  final String? linkTelegram;

  EventEntity({
    required this.id,
    required this.chatName,
    required this.usersCount,
    required this.flag,
    required this.linkTelegram,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }


  @override
  List<Object> get props => [
        id,
        chatName,
        usersCount,
        flag
      ];
}
