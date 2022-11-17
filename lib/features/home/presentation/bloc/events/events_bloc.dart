import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/domain/entities/events/tag_entity.dart';
import 'package:be_loved/features/home/domain/usecases/add_event.dart';
import 'package:be_loved/features/home/domain/usecases/change_position_event.dart';
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
  final ChangePositionEvent changePositionEvent;

  EventsBloc(this.addEvent, this.getEvents, this.deleteEvent, this.changePositionEvent) : super(EventInitialState()) {
    on<GetEventsEvent>(_getEvents);
    on<EventAddEvent>(_addEvents);
    on<EventChangeToHomeEvent>(_addHomeEvents);
    on<SortByTagEvent>(_sortEvents);
    on<EventDeleteEvent>(_deleteEvent);
  }

  List<EventEntity> events = [];
  List<EventEntity> eventsInHome = [];
  List<EventEntity> eventsDeleted = [];
  List<EventEntity> eventsSorted = [];
  TagEntity? selectedTag;


  void _getEvents(GetEventsEvent event, Emitter<EventsState> emit) async {
    emit(EventLoadingState());
    final gotEvents = await getEvents.call(NoParams());
    await Future.delayed(Duration(seconds: 3));
    EventsState state = gotEvents.fold(
      (error) => errorCheck(error),
      (data) {
        events = data;
        eventsSorted = data;
        eventsInHome = getInHomeEvents(data);
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
        selectedTag = null;
        eventsSorted = events;
        return EventAddedState(eventEntity: event.eventEntity);
      },
    );
    emit(state);
  }



  void _addHomeEvents(EventChangeToHomeEvent event, Emitter<EventsState> emit) async {
    emit(EventBlankState());
    if(event.eventEntity == null){
      eventsDeleted.removeWhere((element) => element.id == eventsInHome[event.position].id);
      eventsDeleted.add(eventsInHome[event.position]);
      eventsInHome.removeAt(event.position);
    }else{
      eventsDeleted.removeWhere((element) => element.id == event.eventEntity!.id);
      if(eventsInHome.any((element) => element.id == event.eventEntity!.id)){
        eventsInHome.removeWhere((element) => element.id == event.eventEntity!.id);
      }
      eventsInHome.insert(event.position == 0 
        ? 0 
        : event.position == 1
        ? 1
        : event.position-1, event.eventEntity!);
    }
    print('DELETE LIST: ${eventsDeleted}');
    emit(GotSuccessEventsState());


    Map<String, int> items = {};
    for(var deletedItem in eventsDeleted){
      items['${deletedItem.id}'] = 0;
    }
    for(var inHomeItem in eventsInHome){
      items['${inHomeItem.id}'] = eventsInHome.indexOf(inHomeItem)+1;
    }
    print('DATA TO BACK: ${items}');
    final data = await changePositionEvent.call(ChangePositionEventParams(items: items));
    EventsState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        eventsDeleted = [];
        return GotSuccessEventsState();
      },
    );
    emit(state);
  }





  void _sortEvents(SortByTagEvent event, Emitter<EventsState> emit) async {
    emit(EventBlankState());
    eventsSorted = [];
    if(selectedTag != null && selectedTag!.id == event.tagEntity.id){
      selectedTag = null;
      eventsSorted.addAll(events);
    }else{
      selectedTag = event.tagEntity;
      for(var eventItem in events){
        if(event.tagEntity.events.contains(eventItem.id)){
          eventsSorted.add(eventItem);
        }
      }
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
          eventsDeleted.removeWhere((element) => element.id == id);
          eventsSorted.removeWhere((element) => element.id == id);
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





  List<EventEntity> getInHomeEvents(List<EventEntity> list){
    EventEntity? firstItem;
    EventEntity? secondItem;
    EventEntity? thirdItem;
    List<EventEntity> result = [];

    for(EventEntity item in list){
      if(item.mainPosition != 0){
        if(item.mainPosition == 1){
          firstItem = item;
        }else if(item.mainPosition == 2){
          secondItem = item;
        }else if(item.mainPosition == 3){
          thirdItem = item;
        }
      }
    }
    if(firstItem != null){
      result.add(firstItem);
    }
    if(secondItem != null){
      result.add(secondItem);
    }
    if(thirdItem != null){
      result.add(thirdItem);
    }
    return result;
  }

} 
