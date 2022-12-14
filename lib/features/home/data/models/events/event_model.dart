
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
    required String? photo,
    required bool married,
    required bool allDays,
    required bool repeat,
    required bool notification,
    required int relationId,
    required int mainPosition,
    required User eventCreator,
    required List<int> tagIds,

  }) : super(
    id: id, 
    tagIds: tagIds,
    title: title,
    description: description,
    important: important,
    start: start,
    finish: finish,
    married: married,
    relationId: relationId,
    photo: photo,
    datetimeString: datetimeString,
    repeat: repeat,
    allDays: allDays,
    notification: notification,
    eventCreator: eventCreator,
    mainPosition: mainPosition
  );

  factory EventModel.fromJson(Map<String, dynamic> json) {
    int days = 0;
    DateTime startDate = DateTime.parse(json['start']).toLocal();
    days = calculateDifference(startDate);
    if(json['important'] == true || json['repeat']){
      int currentYearDays = calculateDifference(DateTime(DateTime.now().year, startDate.month, startDate.day));
      if(currentYearDays.isNegative){
        currentYearDays = calculateDifference(DateTime(DateTime.now().year+1, startDate.month, startDate.day));
      }
      days = currentYearDays;
    }
    String date = days.isNegative ? '0' : days.toString();


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
      photo: json['photo'],
      tagIds: (json['tags'] as List).map((e) => e as int).toList(),
      notification: json['notification'],
      mainPosition: json['main_position'],
      eventCreator: User.fromJson(json['event_creator']),
    );
  }
}

int calculateDifference(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;
}