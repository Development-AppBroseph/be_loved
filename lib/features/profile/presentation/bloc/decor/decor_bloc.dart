import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/features/profile/presentation/helpers/background_helper.dart';
import 'package:be_loved/locator.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'decor_event.dart';
part 'decor_state.dart';

class DecorBloc extends Bloc<DecorEvent, DecorState> {
  DecorBloc() : super(DecorInitialState()) {
    on<EditBackgroundEvent>(_editDecorBackground);
    on<GetBackgroundEvent>(_getDecorBackground);
    on<AddBackgroundEvent>(_addDecorBackground);
  }
  int selectedIndex = 0;
  List<String> images = [];


  void _editDecorBackground(EditBackgroundEvent event, Emitter<DecorState> emit) async {
    emit(DecorBlankState());
    await setBackground(event.index);
    sl<AuthConfig>().selectedBackgroundIndex = event.index;
    selectedIndex = event.index;
    emit(DecorEditedSuccessState());
  }



  void _addDecorBackground(AddBackgroundEvent event, Emitter<DecorState> emit) async {
    emit(DecorBlankState());
    await addBackground(event.path);
    images = await getBackgrounds();
    emit(DecorEditedSuccessState());
  }



  void _getDecorBackground(GetBackgroundEvent event, Emitter<DecorState> emit) async {
    emit(DecorBlankState());
    selectedIndex = await getBackgroundIndex();
    images = await getBackgrounds();
    sl<AuthConfig>().selectedBackgroundIndex = selectedIndex;
    emit(DecorEditedSuccessState());
  }







  DecorState errorCheck(Failure failure){
    print('FAIL: $failure');
    if(failure == ConnectionFailure() || failure == NetworkFailure()){
      return DecorInternetErrorState();
    }else if(failure is ServerFailure){
      return DecorErrorState(message: failure.message.length < 100 ? failure.message : 'Ошибка сервера');
    }else{
      return DecorErrorState(message: 'Повторите попытку');
    }
  }
} 
