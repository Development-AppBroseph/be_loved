
import 'package:be_loved/constants/main_config_app.dart';
import 'package:be_loved/features/home/domain/entities/events/tag_entity.dart';

class TagModel extends TagEntity{
  TagModel({
    required int id,
    required String title,
    required int relationId,
    required TagColor color,
    required List<int> events,

  }) : super(
    id: id, 
    title: title,
    relationId: relationId,
    color: color,
    events: events
  );

  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'],
      title: json['name'],
      relationId: json['relation'],
      color: MainConfigApp.tagColors.any((element) => element.colorHex == json['color'])
      ? MainConfigApp.tagColors.where((element) => element.colorHex == json['color']).first
      : MainConfigApp.tagColors.first,
      events: (json['event'] as List).map((e) => e as int).toList(),
    );
  }
}