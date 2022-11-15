part of 'events_bloc.dart';

abstract class EventsState extends Equatable {
  const EventsState();
  @override
  List<Object> get props => [];
}

class EventInitialState extends EventsState {}
class EventLoadingState extends EventsState {}
class EventErrorState extends EventsState {
  final bool isTokenError;
  final String message;
  EventErrorState({required this.message, required this.isTokenError});
}
class EventInternetErrorState extends EventsState{}

class GotSuccessEventsState extends EventsState{}
class EventBlankState extends EventsState{}
class EventAddedState extends EventsState{
  final EventEntity eventEntity;
  EventAddedState({required this.eventEntity});
}
