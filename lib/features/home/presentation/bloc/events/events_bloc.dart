import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/domain/usecases/add_event.dart';
import 'package:be_loved/features/home/domain/usecases/delete_event.dart';
import 'package:be_loved/features/home/domain/usecases/get_events.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetEvents getEvents;
  final AddEvent addEvent;
  final DeleteEvent deleteEvent;

  EventsBloc(this.addEvent, this.getEvents, this.deleteEvent) : super(EventInitialState()) {
    on<GetEventsEvent>(_getEvents);
    on<EventAddEvent>(_addEvents);
    on<EventChangeToHomeEvent>(_addHomeEvents);
    on<EventDeleteEvent>(_deleteEvent);
  }

  List<EventEntity> events = [];
  List<EventEntity> eventsInHome = [];

  void _getEvents(GetEventsEvent event, Emitter<EventsState> emit) async {
    emit(EventLoadingState());
    final gotEvents = await getEvents.call(NoParams());
    await Future.delayed(Duration(seconds: 3));
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
        events = events.reversed.toList();
        events.add(data);
        events = events.reversed.toList();
        return EventAddedState(eventEntity: event.eventEntity);
      },
    );
    emit(state);
  }



  void _addHomeEvents(EventChangeToHomeEvent event, Emitter<EventsState> emit) async {
    emit(EventBlankState());
    if(event.eventEntity == null){
      eventsInHome.removeAt(event.position);
    }else{
      if(eventsInHome.any((element) => element.id == event.eventEntity!.id)){
        eventsInHome.removeWhere((element) => element.id == event.eventEntity!.id);
      }
      eventsInHome.insert(event.position == 0 ? 0 : event.position-1, event.eventEntity!);
    }
    emit(GotSuccessEventsState());
  }





  void _deleteEvent(EventDeleteEvent event, Emitter<EventsState> emit) async {
    emit(EventLoadingState());
    final data = await deleteEvent.call(DeleteEventParams(ids: event.ids));
    EventsState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        for(int id in event.ids){
          events.removeWhere((element) => element.id == id);
          eventsInHome.removeWhere((element) => element.id == id);
        }
        return EventDeletedState();
      },
    );
    emit(state);
  }




  EventsState errorCheck(Failure failure){
    print('FAIL: $failure');
    if(failure == ConnectionFailure() || failure == NetworkFailure()){
      return EventInternetErrorState();
    }else if(failure is ServerFailure){
      if(failure.message == 'token_error'){
        print('token_error');
        return EventErrorState(message: failure.message.length < 100 ? failure.message : 'Вы не авторизованы', isTokenError: true);
      }
      return EventErrorState(message: failure.message.length < 100 ? failure.message : 'Ошибка сервера', isTokenError: false);
    }else{
      return EventErrorState(message: 'Повторите попытку', isTokenError: false);
    }
  }
} 
