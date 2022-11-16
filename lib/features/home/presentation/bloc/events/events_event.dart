part of 'events_bloc.dart';

abstract class EventsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class GetEventsEvent extends EventsEvent{
}
class EventAddEvent extends EventsEvent{
  final EventEntity eventEntity;
  EventAddEvent({required this.eventEntity});
}

class EventChangeToHomeEvent extends EventsEvent{
  final EventEntity? eventEntity;
  final int position;
  EventChangeToHomeEvent({required this.eventEntity, required this.position});
}

class EventDeleteEvent extends EventsEvent{
  final int id;
  EventDeleteEvent({required this.id});
}