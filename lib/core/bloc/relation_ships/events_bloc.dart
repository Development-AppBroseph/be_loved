import 'package:be_loved/core/utils/helpers/events.dart';
import 'package:bloc/bloc.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {

  EventsBloc() : super(AddEventsStated()) {
    on<AddEvent>(_addEvent);
  }

  void _addEvent(AddEvent event, Emitter<EventsState> emit) async {
    emit(AddEventsState(events: event.events));
  }
}
