import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/profile/domain/entities/back_entity.dart';
import 'package:be_loved/features/profile/domain/entities/back_file_entity.dart';
import 'package:be_loved/features/profile/domain/usecases/edit_backgrounds_info.dart';
import 'package:be_loved/features/profile/domain/usecases/get_backgrounds_info.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'decor_event.dart';
part 'decor_state.dart';

class DecorBloc extends Bloc<DecorEvent, DecorState> {
  final GetBackgroundsInfo getBackgroundInfo;
  final EditBackgroundsInfo editBackgroundInfo;

  DecorBloc(this.getBackgroundInfo, this.editBackgroundInfo)
      : super(DecorInitialState()) {
    on<EditBackgroundEvent>(_editDecorBackground);
    on<GetBackgroundEvent>(_getDecorBackground);
    on<AddBackgroundEvent>(_addDecorBackground);
  }
  // int selectedIndex = 0;
  // List<String> images = [];

  BackEntity? back;

  void _editDecorBackground(
      EditBackgroundEvent event, Emitter<DecorState> emit) async {
    // emit(DecorLoadingState());
    // // await setBackground(event.index);
    // // sl<AuthConfig>().selectedBackgroundIndex = event.index;
    // // selectedIndex = event.index;
    // final gotBack = await getBackgroundInfo.call(NoParams());
    // DecorState state = gotBack.fold(
    //   (error) => errorCheck(error),
    //   (data) {
    //     back = data;
    //     return DecorGotSuccessState();
    //   },
    // );
    // emit(state);
    emit(DecorBlankState());
    back!.assetPhoto = event.assetPhoto;
    back!.backPhoto = event.backFileEntity?.id;
    emit(DecorEditedSuccessState());
    // DecorState state = gotBack.fold(
    //   (error) => errorCheck(error),
    //   (data) {
    //     add(GetBackgroundEvent());
    //     return DecorGotSuccessState();
    //   },
    // );
    // emit(state);
  }

  void _addDecorBackground(
      AddBackgroundEvent event, Emitter<DecorState> emit) async {
    // emit(DecorBlankState());
    // await addBackground(event.path);
    // images = await getBackgrounds();
    // emit(DecorEditedSuccessState());
    print('ADD');
    emit(DecorBlankState());
    final gotBack = await editBackgroundInfo
        .call(EditBackgroundsInfoParams(back: back!, filePath: event.path));
    DecorState state = gotBack.fold(
      (error) => errorCheck(error),
      (data) {
        return DecorGotSuccessState();
      },
    );
    emit(state);
    add(GetBackgroundEvent());
  }

  void _getDecorBackground(
      GetBackgroundEvent event, Emitter<DecorState> emit) async {
    // emit(DecorBlankState());
    // // selectedIndex = await getBackgroundIndex();
    // // images = await getBackgrounds();
    // // sl<AuthConfig>().selectedBackgroundIndex = selectedIndex;
    // emit(DecorEditedSuccessState());
    emit(DecorLoadingState());
    final gotBack = await getBackgroundInfo.call(NoParams());
    DecorState state = gotBack.fold(
      (error) => errorCheck(error),
      (data) {
        back = data;
        // print('BACK DATA: $data');
        return DecorGotSuccessState();
      },
    );
    emit(state);
  }

  DecorState errorCheck(Failure failure) {
    print('FAIL: $failure');
    if (failure == ConnectionFailure() || failure == NetworkFailure()) {
      return DecorInternetErrorState();
    } else if (failure is ServerFailure) {
      return DecorErrorState(
          message: failure.message.length < 100
              ? failure.message
              : 'Ошибка сервера');
    } else {
      return DecorErrorState(message: 'Повторите попытку');
    }
  }
}
