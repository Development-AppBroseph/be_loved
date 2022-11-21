import 'package:be_loved/constants/main_config_app.dart';
import 'package:equatable/equatable.dart';

class TagEntity extends Equatable {
  final int id;
  final int relationId;
  final String title;
  final TagColor color;
  final List<int> events;
  final bool important;

  TagEntity({
    required this.id,
    required this.title,
    required this.relationId,
    required this.color,
    required this.events,
    required this.important,
  });


  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': title,
      // 'relation': relationId,
      'color': color.colorHex,
      'event': events,
    };
  }


  @override
  List<Object> get props => [
        id,
        title,
        relationId,
        color,
        events,
        important
      ];
}
