// import 'package:be_loved/core/error/failures.dart';
// import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
// import 'package:be_loved/features/home/domain/usecases/delete_event.dart';
// import 'package:be_loved/features/home/domain/usecases/get_old_events.dart';
// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// part 'old_events_event.dart';
// part 'old_events_state.dart';

// class OldEventsBloc extends Bloc<OldEventsEvent, OldEventsState> {
//   GetOldEvents getOldEvents;
//   DeleteEvent deleteEvent;

//   OldEventsBloc(this.getOldEvents, this.deleteEvent) : super(OldEventInitialState()) {
//     on<GetOldEventsEvent>(_getOldEvents);
//     on<DeleteOldEventEvent>(_deleteEvents);
//   }

//   List<EventEntity> events = [];
//   EventEntity? selectedEvent;
  
//   int page = 0;
//   bool isLoading = false;
//   bool isEnd = false;

//   void _getOldEvents(GetOldEventsEvent event, Emitter<OldEventsState> emit) async {

//     //pagination
//     isLoading = true;
//     if (event.isReset) {
//       emit(OldEventLoadingState());
//       page = 0;
//       isEnd = false;
//       events = [];
//     }else{
//       emit(OldEventBlankState());
//     }
//     page++;
//     print('OLD EVENTS GET PAGE: $page');

//     final gotOldEvents = await getOldEvents.call(page);
//     OldEventsState state = gotOldEvents.fold(
//       (error) => errorCheck(error),
//       (data) {
//         //pagination
//         if(data.any((element) => events.any((file) => file.id == element.id))){
//           isEnd = true;
//         }else{
//           if (event.isReset) {
//             events = data;
//           } else {
//             events.addAll(data);
//           }
//         }

//         return GotSuccessOldEventsState();
//       },
//     );
//     isLoading = false;
//     emit(state);
//   }



//   void _deleteEvents(DeleteOldEventEvent event, Emitter<OldEventsState> emit) async {
//     emit(OldEventBlankState());
//     final data = await deleteEvent.call(DeleteEventParams(ids: [event.id]));
//     OldEventsState state = data.fold(
//       (error) => errorCheck(error),
//       (data) {
//         return OldEventDeletedState();
//       },
//     );
//     emit(state);
//   }


//   OldEventsState errorCheck(Failure failure){
//     print('FAIL: $failure');
//     if(failure == ConnectionFailure() || failure == NetworkFailure()){
//       return OldEventInternetErrorState();
//     }else if(failure is ServerFailure){
//       return OldEventErrorState(message: failure.message.length < 100 ? failure.message : 'Ошибка сервера');
//     }else{
//       return OldEventErrorState(message: 'Повторите попытку');
//     }
//   }
// } 
