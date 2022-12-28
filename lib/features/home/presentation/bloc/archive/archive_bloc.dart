import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/entities/archive/memory_entity.dart';
import 'package:be_loved/features/home/domain/usecases/get_memory_info.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'archive_event.dart';
part 'archive_state.dart';

class ArchiveBloc extends Bloc<ArchiveEvent, ArchiveState> {
  final GetMemoryInfo getMemoryInfo;

  ArchiveBloc(this.getMemoryInfo) : super(ArchiveInitialState()) {
    on<GetMemoryInfoEvent>(_getMemoryInfo);
  }

  MemoryEntity? memoryEntity;

  void _getMemoryInfo(GetMemoryInfoEvent event, Emitter<ArchiveState> emit) async {
    emit(ArchiveLoadingState());
    final gotGallery = await getMemoryInfo.call(NoParams());
    ArchiveState state = gotGallery.fold(
      (error) => errorCheck(error),
      (data) {
        memoryEntity = data;
        return GotSuccessMemoryInfoState();
      },
    );
    emit(state);
  }



  ArchiveState errorCheck(Failure failure){
    print('FAIL: $failure');
    if(failure == ConnectionFailure() || failure == NetworkFailure()){
      return ArchiveInternetErrorState();
    }else if(failure is ServerFailure){
      if(failure.message == 'token_error'){
        print('token_error');
        return ArchiveErrorState(message: failure.message.length < 100 ? failure.message : 'Вы не авторизованы', isTokenError: true);
      }
      return ArchiveErrorState(message: failure.message.length < 100 ? failure.message : 'Ошибка сервера', isTokenError: false);
    }else{
      return ArchiveErrorState(message: 'Повторите попытку', isTokenError: false);
    }
  }
} 
