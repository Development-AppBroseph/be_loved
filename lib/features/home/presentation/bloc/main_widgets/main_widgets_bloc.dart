import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/main_widgets/main_widgets_entity.dart';
import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:be_loved/features/home/domain/usecases/add_file_widget.dart';
import 'package:be_loved/features/home/domain/usecases/add_purpose_widget.dart';
import 'package:be_loved/features/home/domain/usecases/delete_file_widget.dart';
import 'package:be_loved/features/home/domain/usecases/delete_purpose_widget.dart';
import 'package:be_loved/features/home/domain/usecases/get_main_widgets.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'main_widgets_event.dart';
part 'main_widgets_state.dart';

class MainWidgetsBloc extends Bloc<MainWidgetsEvent, MainWidgetsState> {
  GetMainWidgets getMainWidgets;
  AddFileWidget addFileWidget;
  AddPurposeWidget addPurposeWidget;
  DeleteFileWidget deleteFileWidget;
  DeletePurposeWidget deletePurposeWidget;

  MainWidgetsBloc(this.getMainWidgets, this.addFileWidget, this.addPurposeWidget, this.deleteFileWidget, this.deletePurposeWidget) : super(MainWidgetsInitialState()) {
    on<GetMainWidgetsEvent>(_getMainWidgets);
    on<AddFileWidgetEvent>(_addFileWidget);
    on<AddPurposeWidgetEvent>(_addPurposeWidget);
    on<DeleteFileWidgetEvent>(_deleteFileWidget);
    on<DeletePurposeWidgetEvent>(_deletePurposeWidget);
  }

  MainWidgetsEntity mainWidgets = MainWidgetsEntity(file: null, purposes: []);


  void _getMainWidgets(GetMainWidgetsEvent event, Emitter<MainWidgetsState> emit) async {
    if(mainWidgets.file == null && mainWidgets.purposes.isEmpty){
      emit(MainWidgetsLoadingState());
    }else{
      emit(MainWidgetsBlankState());
    }
    final gotMainWidgets = await getMainWidgets.call(NoParams());
    MainWidgetsState state = gotMainWidgets.fold(
      (error) => errorCheck(error),
      (data) {
        mainWidgets = data;
        mainWidgets.purposes = setStatusPurpose(mainWidgets.purposes);
        print('DATA MAIN: ${data.purposes}');
        return GotSuccessMainWidgetsState();
      },
    );
    emit(state);
  }



  void _addFileWidget(AddFileWidgetEvent event, Emitter<MainWidgetsState> emit) async {
    emit(MainWidgetsBlankState());
    final data = await addFileWidget.call(AddFileWidgetParams(id: event.file.id));
    MainWidgetsState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        mainWidgets.file = event.file;
        return MainWidgetsAddedState(isRefresh: true);
      },
    );
    emit(state);
  }




  void _addPurposeWidget(AddPurposeWidgetEvent event, Emitter<MainWidgetsState> emit) async {
    if(!mainWidgets.purposes.any((element) => element.id == event.purpose.id)){
      emit(MainWidgetsBlankState());
      final data = await addPurposeWidget.call(AddPurposeWidgetParams(id: event.purpose.id));
      MainWidgetsState state = data.fold(
        (error) => errorCheck(error),
        (data) {
          mainWidgets.purposes.add(event.purpose);
          return MainWidgetsAddedState(isRefresh: true);
        },
      );
      emit(state);
    }
  }




  void _deleteFileWidget(DeleteFileWidgetEvent event, Emitter<MainWidgetsState> emit) async {
    emit(MainWidgetsBlankState());
    final data = await deleteFileWidget.call(DeleteFileWidgetParams(id: event.id));
    MainWidgetsState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        mainWidgets.file = null;
        return MainWidgetsAddedState();
      },
    );
    emit(state);
  }




  void _deletePurposeWidget(DeletePurposeWidgetEvent event, Emitter<MainWidgetsState> emit) async {
    emit(MainWidgetsBlankState());
    final data = await deletePurposeWidget.call(DeletePurposeWidgetParams(id: event.id));
    MainWidgetsState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        mainWidgets.purposes.removeWhere((el) => el.widgetId == event.id);
        return MainWidgetsAddedState();
      },
    );
    emit(state);
  }

  MainWidgetsState errorCheck(Failure failure){
    print('FAIL: $failure');
    if(failure == ConnectionFailure() || failure == NetworkFailure()){
      return MainWidgetsInternetErrorState();
    }else if(failure is ServerFailure){
      return MainWidgetsErrorState(message: failure.message.length < 100 ? failure.message : 'Ошибка сервера');
    }else{
      return MainWidgetsErrorState(message: 'Повторите попытку');
    }
  }




  List<PurposeEntity> setStatusPurpose(List<PurposeEntity> list){
    for(int i = 0; i < list.length; i++){
      if(list[i].verdict == null){
        list[i].inHistory = false;
        list[i].inProcess = false;
      }else if(list[i].verdict == 'Ожидание'){
        list[i].inHistory = false;
        list[i].inProcess = true;
      }else if(list[i].verdict == 'Принято'){
        list[i].inHistory = true;
        list[i].inProcess = false;
      }
    }
    return list;
  }
} 
