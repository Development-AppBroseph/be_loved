import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:equatable/equatable.dart';

class EventEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final bool important;
  final DateTime start;
  final DateTime finish;
  final String datetimeString;
  final String? photo;
  final bool married;
  final bool allDays;
  final bool repeat;
  final bool notification;
  final int relationId;
  final int mainPosition;
  final User eventCreator;
  final List<int> tagIds;
  final String? cycle;

  const EventEntity({
    required this.id,
    required this.tagIds,
    required this.title,
    required this.description,
    required this.important,
    required this.start,
    required this.finish,
    required this.datetimeString,
    required this.married,
    required this.relationId,
    required this.mainPosition,
    required this.photo,
    required this.notification,
    required this.repeat,
    required this.allDays,
    required this.eventCreator,
    required this.cycle,
  });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': title,
      'description': description,
      // 'important': important,
      'start': start.toUtc(),
      'finish': finish.toUtc(),
      'married': married,
      // 'relation': relationId,
      'all_day': allDays,
      'repeat': repeat,
      'notification': notification,
      'tags': tagIds,
      'cycle': cycle,
      // 'main_position': mainPosition
      // 'event_creator': eventCreator
    };
  }

  @override
  List<Object> get props =>
      [id, title, description, important, start, finish, married, relationId];
}
