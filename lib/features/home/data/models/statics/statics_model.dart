import 'package:be_loved/features/home/domain/entities/statics/statics_entity.dart';

class StaticsModel extends StaticsEntity{
  StaticsModel({
    required int events,
    required int completeTargets,
    required int archive,

  }) : super(
    events: events,
    completeTargets: completeTargets,
    archive: archive
  );

  factory StaticsModel.fromJson(Map<String, dynamic> json) {
    return StaticsModel(
      events: json['events'],
      completeTargets: json['complete_targets'],
      archive: json['archive'] ?? json['archive:'],
    );
  }
}