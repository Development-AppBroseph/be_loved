part of 'events_bloc.dart';

abstract class EventsState {}

class AddEventsStated extends EventsState {}

class AddEventsState extends EventsState {
  Events events;

  AddEventsState({required this.events});
}
