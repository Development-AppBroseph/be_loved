import 'package:equatable/equatable.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class EventEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final bool important;
  final DateTime datetime;
  final String datetimeString;
  final bool married;
  final int relationId;

  EventEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.important,
    required this.datetime,
    required this.datetimeString,
    required this.married,
    required this.relationId
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': title,
      'description': description,
      'important': important,
      'datetime': datetimeString,
      'married': married,
      'relation': relationId,
    };
  }


  @override
  List<Object> get props => [
        id,
        title,
        description,
        important,
        datetime,
        married,
        relationId
      ];
}
