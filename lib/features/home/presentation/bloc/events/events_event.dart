part of 'events_bloc.dart';

abstract class EventsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class GetEventsEvent extends EventsEvent{}

class EventAddEvent extends EventsEvent{
  final EventEntity eventEntity;
  EventAddEvent({required this.eventEntity});
}

class EventEditEvent extends EventsEvent{
  final EventEntity eventEntity;
  File? photo;
  bool isDeletePhoto;
  EventEditEvent({required this.eventEntity, this.photo, this.isDeletePhoto = false});
}

class EventChangeToHomeEvent extends EventsEvent{
  final EventEntity? eventEntity;
  final int position;
  EventChangeToHomeEvent({required this.eventEntity, required this.position});
}

class EventDeleteEvent extends EventsEvent{
  final List<int> ids;
  EventDeleteEvent({required this.ids});
}


class SortByTagEvent extends EventsEvent{
  final TagEntity tagEntity;
  SortByTagEvent({required this.tagEntity});
}

class ResetSortEvent extends EventsEvent{}

class GetOldEventsEvent extends EventsEvent{
  final bool isReset;
  GetOldEventsEvent({required this.isReset});
}
