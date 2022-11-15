
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';

class EventModel extends EventEntity{
  EventModel({
    required int id,
    required String title,
    required String description,
    required bool important,
    required DateTime start,
    required DateTime finish,
    required String datetimeString,
    required bool married,
    required bool allDays,
    required bool repeat,
    required bool notification,
    required int relationId,
    required User eventCreator,

  }) : super(
    id: id, 
    title: title,
    description: description,
    important: important,
    start: start,
    finish: finish,
    married: married,
    relationId: relationId,
    datetimeString: datetimeString,
    repeat: repeat,
    allDays: allDays,
    notification: notification,
    eventCreator: eventCreator
  );

  factory EventModel.fromJson(Map<String, dynamic> json) {
    Duration duration = DateTime.parse(json['finish']).toUtc().difference(DateTime.now().toUtc());

    String date = duration.inDays.isNegative || duration.inDays == 0 ? '1' :  duration.inDays.toString();
    return EventModel(
      id: json['id'],
      title: json['name'],
      description: json['description'] ?? '',
      important: json['important'],
      start: json['start'] == null ? DateTime.now() : DateTime.parse(json['start']).toLocal(),
      finish: json['finish'] == null ? DateTime.now() : DateTime.parse(json['finish']).toLocal(),
      married: json['married'],
      relationId: json['relation'],
      datetimeString: date,
      allDays: json['all_day'],
      repeat: json['repeat'],
      notification: json['notification'],
      eventCreator: User.fromJson(json['event_creator']),
    );
  }
}