import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';

String countEventsText(List<EventEntity> list) {
  // int length = list.where((element)
  //                       => int.parse(element.datetimeString) < 7).toList().length;

  int length = list.length;
  if (length == 0) return '$length событий';
  if (length == 1) return '$length событие';
  if (length > 0 && length < 5) return '$length событий';
  if (length >= 5 && length <= 21) return '$length событий';
  if (length % 5 == 0) return '$length событии';
  if (length == 11) return '$length событий';

  return '$length события';
}
