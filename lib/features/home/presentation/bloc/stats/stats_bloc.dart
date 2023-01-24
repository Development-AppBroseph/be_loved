import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/entities/statics/statics_entity.dart';
import 'package:be_loved/features/profile/domain/usecases/get_stats.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'stats_event.dart';
part 'stats_state.dart';

class StaticsBloc extends Bloc<StaticsEvent, StaticsState> {
  final GetStatics getStaticsInfo;

  StaticsBloc(this.getStaticsInfo) : super(StaticsInitialState()) {
    on<GetStatsInfoEvent>(_getStaticsInfo);
  }

  StaticsEntity? staticsEntity;

  void _getStaticsInfo(GetStatsInfoEvent event, Emitter<StaticsState> emit) async {
    emit(StaticsLoadingState());
    final gotGallery = await getStaticsInfo.call(NoParams());
    StaticsState state = gotGallery.fold(
      (error) => errorCheck(error),
      (data) {
        staticsEntity = data;
        return GotSuccessStaticsInfoState();
      },
    );
    emit(state);
  }



  StaticsState errorCheck(Failure failure){
    print('FAIL: $failure');
    if(failure == ConnectionFailure() || failure == NetworkFailure()){
      return StaticsInternetErrorState();
    }else if(failure is ServerFailure){
      if(failure.message == 'token_error'){
        print('token_error');
        return StaticsErrorState(message: failure.message.length < 100 ? failure.message : 'Вы не авторизованы', isTokenError: true);
      }
      return StaticsErrorState(message: failure.message.length < 100 ? failure.message : 'Ошибка сервера', isTokenError: false);
    }else{
      return StaticsErrorState(message: 'Повторите попытку', isTokenError: false);
    }
  }
} 
