import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/features/theme/data/theme_data.dart';
import 'package:be_loved/locator.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitialState()) {
    on<UpdateThemeEvent>(_editThemeBackground);
    on<SetThemeEvent>(_setTheme);
    on<GetThemeLocalEvent>(_getTheme);
  }
  int idx = 0;


  void _editThemeBackground(UpdateThemeEvent event, Emitter<ThemeState> emit) async {
    emit(ThemeBlankState());
    setTheme(event.index);
    idx = event.index;
    sl<AuthConfig>().idx = idx;
    emit(ThemeEditedSuccessState(isChanges: false));
    // emit(ThemeEditedSuccessState(isChanges: true));
  }

  void _setTheme(SetThemeEvent event, Emitter<ThemeState> emit) async {
    emit(ThemeBlankState());
    setTheme(event.index);
    sl<AuthConfig>().idx = event.index;
    idx = event.index;
    emit(ThemeEditedSuccessState(isChanges: false));
  }



  void _getTheme(GetThemeLocalEvent event, Emitter<ThemeState> emit) async {
    emit(ThemeBlankState());
    idx = await getThemeIndex();
    sl<AuthConfig>().idx = idx;
    emit(ThemeInitialState());
  }







  ThemeState errorCheck(Failure failure){
    print('FAIL: $failure');
    if(failure == ConnectionFailure() || failure == NetworkFailure()){
      return ThemeInternetErrorState();
    }else if(failure is ServerFailure){
      return ThemeErrorState(message: failure.message.length < 100 ? failure.message : 'Ошибка сервера');
    }else{
      return ThemeErrorState(message: 'Повторите попытку');
    }
  }
} 
