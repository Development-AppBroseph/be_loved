import 'dart:io';

import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/domain/entities/events/tag_entity.dart';
import 'package:be_loved/features/home/domain/usecases/add_event.dart';
import 'package:be_loved/features/home/domain/usecases/change_position_event.dart';
import 'package:be_loved/features/home/domain/usecases/delete_event.dart';
import 'package:be_loved/features/home/domain/usecases/edit_event.dart';
import 'package:be_loved/features/home/domain/usecases/get_events.dart';
import 'package:be_loved/features/home/domain/usecases/get_old_events.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final GetEvents getEvents;
  final AddEvent addEvent;
  final EditEvent editEvent;
  final DeleteEvent deleteEvent;
  final ChangePositionEvent changePositionEvent;

  final GetOldEvents getOldEvents;

  EventsBloc(this.addEvent, this.getEvents, this.deleteEvent, this.changePositionEvent, this.editEvent, this.getOldEvents) : super(EventInitialState()) {
    on<GetEventsEvent>(_getEvents);
    on<EventAddEvent>(_addEvents);
    on<EventEditEvent>(_editEvents);
    on<EventChangeToHomeEvent>(_addHomeEvents);
    on<SortByTagEvent>(_sortEvents);
    on<EventDeleteEvent>(_deleteEvent);
    on<ResetSortEvent>(_resetEvents);
    on<GetOldEventsEvent>(_getOldEvents);
  }

  List<EventEntity> events = [];
  List<EventEntity> eventsInHome = [];
  List<EventEntity> eventsDeleted = [];
  List<EventEntity> eventsSorted = [];
  TagEntity? selectedTag;
  int eventDetailSelectedId = 0;


  //Old events
  List<EventEntity> eventsOld = [];
  int page = 0;
  bool isLoading = false;
  bool isEnd = false;


  void _getOldEvents(GetOldEventsEvent event, Emitter<EventsState> emit) async {

    //pagination
    isLoading = true;
    if (event.isReset) {
      emit(OldEventLoadingState());
      page = 0;
      isEnd = false;
      eventsOld = [];
    }else{
      emit(EventBlankState());
    }
    page++;
    print('OLD EVENTS GET PAGE: $page');

    final gotOldEvents = await getOldEvents.call(page);
    EventsState state = gotOldEvents.fold(
      (error) => errorCheck(error),
      (data) {
        //pagination
        if(data.any((element) => eventsOld.any((file) => file.id == element.id))){
          isEnd = true;
        }else{
          if (event.isReset) {
            eventsOld = data;
          } else {
            eventsOld.addAll(data);
          }
        }

        return GotSuccessOldEventsState();
      },
    );
    isLoading = false;
    emit(state);
  }

  void _getEvents(GetEventsEvent event, Emitter<EventsState> emit) async {
    emit(EventLoadingState());
    final gotEvents = await getEvents.call(NoParams());
    EventsState state = gotEvents.fold(
      (error) => errorCheck(error),
      (data) {
        data.sort(((a, b) => int.parse(a.datetimeString).compareTo(int.parse(b.datetimeString))));
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
        List<EventEntity> newSortedList = [];
        bool isAdded = false;
        for(EventEntity eventItem in events){
          print('TEST: ${getEventStart(eventItem).millisecondsSinceEpoch >= getEventStart(data).millisecondsSinceEpoch}');
          if(!isAdded && getEventStart(eventItem).millisecondsSinceEpoch >= getEventStart(data).millisecondsSinceEpoch){
            newSortedList.add(data);
            isAdded = true;
          }
          newSortedList.add(eventItem);
        }
        if(!isAdded){
          newSortedList.add(data);
        }
        // events = events.reversed.toList();
        // events.add(data);
        // events = events.reversed.toList();
        events = newSortedList;
        selectedTag = null;
        eventsSorted = events;
        return EventAddedState(eventEntity: event.eventEntity);
      },
    );
    emit(state);
  }




  void _editEvents(EventEditEvent event, Emitter<EventsState> emit) async {
    emit(EventLoadingState());
    final data = await editEvent.call(EditEventParams(eventEntity: event.eventEntity, photo: event.photo, isDeletePhoto: event.isDeletePhoto));
    EventsState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        events.removeWhere((element) => element.id == event.eventEntity.id);
        List<EventEntity> newSortedList = [];
        bool isAdded = false;
        for(EventEntity eventItem in events){
          print('TEST: ${getEventStart(eventItem).millisecondsSinceEpoch >= getEventStart(data).millisecondsSinceEpoch}');
          if(!isAdded && getEventStart(eventItem).millisecondsSinceEpoch >= getEventStart(data).millisecondsSinceEpoch){
            newSortedList.add(data);
            isAdded = true;
          }
          newSortedList.add(eventItem);
        }
        if(!isAdded){
          newSortedList.add(data);
        }
        events = newSortedList;
        selectedTag = null;
        eventsSorted = events;
        if(eventsInHome.any((element) => element.id == event.eventEntity.id,)){
          for(int i = 0; i < eventsInHome.length; i++){
            if(eventsInHome[i].id == event.eventEntity.id){
              eventsInHome[i] = data;
            }
          }
        }

        //Old
        if(eventsOld.any((element) => element.id == event.eventEntity.id,)){
          for(int i = 0; i < eventsOld.length; i++){
            if(eventsOld[i].id == event.eventEntity.id){
              eventsOld[i] = data;
            }
          }
        }
        return EventAddedState(eventEntity: data);
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



  void _resetEvents(ResetSortEvent event, Emitter<EventsState> emit) async {
    emit(EventBlankState());
    eventsSorted = events;
    selectedTag = null;
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
          eventsOld.removeWhere((element) => element.id == id);
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




  DateTime getEventStart(EventEntity event){
    return DateTime.now().add(Duration(days: int.parse(event.datetimeString)));
  }

} 
