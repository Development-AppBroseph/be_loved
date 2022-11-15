
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';

class EventModel extends EventEntity{
  EventModel({
    required int id,
    required String title,
    required String description,
    required bool important,
    required DateTime datetime,
    required String datetimeString,
    required bool married,
    required int relationId,

  }) : super(
    id: id, 
    title: title,
    description: description,
    important: important,
    datetime: datetime,
    married: married,
    relationId: relationId,
    datetimeString: datetimeString
  );

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    id: json['id'],
    title: json['name'],
    description: json['description'],
    important: json['important'],
    datetime: json['datetime'] == null ? DateTime.now() : DateTime.parse(json['datetime']).toLocal(),
    married: json['married'],
    relationId: json['relation'],
    datetimeString: DateTime.fromMillisecondsSinceEpoch(
                                                    DateTime.parse(json['datetime']).toUtc().millisecond -
                                                        DateTime.now()
                                                            .millisecond)
                                                .day
                                                .toString()
  );
}