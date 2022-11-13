part of 'events_bloc.dart';

abstract class EventsEvent {}

class AddEvent extends EventsEvent {
  Events events;

  AddEvent({required this.events});
}
