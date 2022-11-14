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
