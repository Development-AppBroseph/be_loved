
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';

class EventModel extends EventEntity{
  EventModel({
    required int id,
    required String chatName,
    required int usersCount,
    required bool flag,
    required String? linkTelegram,

  }) : super(
    id: id, 
    chatName: chatName,
    usersCount: usersCount,
    flag: flag,
    linkTelegram: linkTelegram
  );

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    id: json['chat_id'],
    chatName: json['chat_name'],
    usersCount: json['users_count'],
    linkTelegram: json['link'],
    flag: json['flag']
  );
}