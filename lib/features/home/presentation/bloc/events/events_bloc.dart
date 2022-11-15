import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/domain/usecases/add_event.dart';
import 'package:be_loved/features/home/domain/usecases/get_events.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetEvents getEvents;
  final AddEvent addEvent;
  EventsBloc(this.addEvent, this.getEvents) : super(EventInitialState()) {
    on<GetEventsEvent>(_getEvents);
    on<EventAddEvent>(_addEvents);
  }

  List<EventEntity> events = [];

  void _getEvents(GetEventsEvent event, Emitter<EventsState> emit) async {
    emit(EventLoadingState());
    final gotEvents = await getEvents.call(NoParams());
    EventsState state = gotEvents.fold(
      (error) => errorCheck(error),
      (data) {
        events = data;
        return GotSuccessEventsState();
      },
    );
    emit(state);
  }



  void _addEvents(EventAddEvent event, Emitter<EventsState> emit) async {
    emit(EventLoadingState());
    final data = await addEvent.call(AddEventParams(eventEntity: event.eventEntity));
    EventsState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        return EventAddedState(eventEntity: event.eventEntity);
      },
    );
    emit(state);
  }




  EventsState errorCheck(Failure failure){
    print('FAIL: $failure');
    if(failure == ConnectionFailure() || failure == NetworkFailure()){
      return EventInternetErrorState();
    }else if(failure is ServerFailure){
      return EventErrorState(message: failure.message.length < 100 ? failure.message : 'Ошибка сервера');
    }else{
      return EventErrorState(message: 'Повторите попытку');
    }
  }
} 
