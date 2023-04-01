import 'dart:async';

import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/models/common/common.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/entities/purposes/actual_entiti.dart';
import 'package:be_loved/features/home/domain/entities/purposes/full_purpose_entity.dart';
import 'package:be_loved/features/home/domain/entities/purposes/promos_entiti.dart';
import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:be_loved/features/home/domain/usecases/cancel_purpose.dart';
import 'package:be_loved/features/home/domain/usecases/complete_purpose.dart';
import 'package:be_loved/features/home/domain/usecases/get_actual.dart';
import 'package:be_loved/features/home/domain/usecases/get_available_purposes.dart';
import 'package:be_loved/features/home/domain/usecases/get_history_purpose.dart';
import 'package:be_loved/features/home/domain/usecases/get_in_process_purpose.dart';
import 'package:be_loved/features/home/domain/usecases/get_promos.dart';
import 'package:be_loved/features/home/domain/usecases/get_season_purpose.dart';
import 'package:be_loved/features/home/domain/usecases/send_photo_purpose.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'purpose_event.dart';
part 'purpose_state.dart';

class PurposeBloc extends Bloc<PurposeEvent, PurposeState> {
  final GetSeasonPurpose getSeasonPurpose;
  final GetAvailablePurposes getAvailablePurposes;
  final GetInProcessPurpose getInProcessPurpose;
  final CompletePurpose completePurpose;
  final SendPhotoPurpose sendPhotoPurpose;
  final CancelPurpose cancelPurpose;
  final GetHistoryPurpose getHistoryPurpose;
  final GetPromo getPromos;
  final GetActual getActual;

  PurposeBloc(
    this.getSeasonPurpose,
    this.getAvailablePurposes,
    this.getInProcessPurpose,
    this.completePurpose,
    this.sendPhotoPurpose,
    this.cancelPurpose,
    this.getHistoryPurpose,
    this.getPromos,
    this.getActual,
  ) : super(
          PurposeInitialState(),
        ) {
    on<GetAllPurposeDataEvent>(_getAllPurposeData);
    on<CompletePurposeEvent>(_completePurpose);
    on<CancelPurposeEvent>(_cancelPurpose);
    on<SendPhotoPurposeEvent>(_sendPhotoPurpose);
    on<GetPromosEvent>(_getPromos);
    on<GetActualEvent>(_getActual);
  }

  List<PurposeEntity> allPurposes = [];
  PurposeEntity? seasonPurpose;
  List<PurposeEntity> availablePurposes = [];
  List<FullPurposeEntity> inProcessPurposes = [];
  List<FullPurposeEntity> historyPurposes = [];
  List<PromosEntiti> promos = [];
  List<ActualEntiti> actual = [];

  void _getPromos(GetPromosEvent event, Emitter<PurposeState> emit) async {
    emit(PurposeLoadingState());
    final promo = await getPromos.call(PromosParams());
    promo.fold(
      (error) => errorCheck(error),
      (data) {
        promos = data;
        return GotPurposeDataState();
      },
    );
    emit(state);
    emit(PurposeBlankState());
  }

  FutureOr<void> _getActual(
      GetActualEvent event, Emitter<PurposeState> emit) async {
    emit(PurposeLoadingState());
    final promo = await getActual.call(ActualParams());
    promo.fold(
      (error) => errorCheck(error),
      (data) {
        actual = data;
        return GotPurposeDataState();
      },
    );
    emit(state);
    emit(PurposeBlankState());
  }

  void _getAllPurposeData(
      GetAllPurposeDataEvent event, Emitter<PurposeState> emit) async {
    print('GET PURPOSE DATA');
    emit(PurposeLoadingState());

    //Getting season purpsose(target)
    emit(PurposeLoadingState());
    final gotPurpose = await getSeasonPurpose.call(NoParams());
    PurposeState state = gotPurpose.fold(
      (error) => errorCheck(error),
      (data) {
        seasonPurpose = data;
        seasonPurpose!.inHistory =
            seasonPurpose!.verdict == 'Принято' ? true : false;
        seasonPurpose!.inProcess =
            seasonPurpose!.verdict == 'Ожидание' ? true : false;
        return GotPurposeDataState();
      },
    );
    emit(state);
    emit(PurposeBlankState());

    //Getting available purposes by lat and long
    final gotPurposes = await getAvailablePurposes
        .call(GetAvailablePurposesParams(lat: 59.886086, long: 30.285244));
    state = gotPurposes.fold(
      (error) => errorCheck(error),
      (data) {
        availablePurposes = data;
        allPurposes = [];
        allPurposes.addAll(data);
        return GotPurposeDataState();
      },
    );
    emit(state);
    emit(PurposeBlankState());

    //Getting in process purposes
    final gotInProcessPurposes = await getInProcessPurpose.call(NoParams());
    state = gotInProcessPurposes.fold(
      (error) => errorCheck(error),
      (data) {
        inProcessPurposes = data;
        allPurposes.addAll(getPurposeListFromFullData(data));
        return GotPurposeDataState();
      },
    );
    emit(state);
    emit(PurposeBlankState());

    //Getting history purposes
    final gotHistoryPurposes = await getHistoryPurpose.call(NoParams());
    state = gotHistoryPurposes.fold(
      (error) => errorCheck(error),
      (data) {
        historyPurposes = data;
        return GotPurposeDataState();
      },
    );
    emit(state);
  }

  void _completePurpose(
      CompletePurposeEvent event, Emitter<PurposeState> emit) async {
    print('COMPLETE PURPOSE DATA ID: ${event.target}');
    emit(PurposeLoadingState());

    //Complete and to in process
    final gotPurpose =
        await completePurpose.call(CompletePurposeParams(target: event.target));
    PurposeState state = gotPurpose.fold((error) => errorCheck(error), (data) {
      clearAll();
      return CompletedPurposeState();
    });
    emit(state);
  }

  void _cancelPurpose(
      CancelPurposeEvent event, Emitter<PurposeState> emit) async {
    print('CANCEL PURPOSE DATA');
    emit(PurposeLoadingState());

    //Cancel and to available
    final gotPurpose = await cancelPurpose.call(CancelPurposeParams(
        target: seasonPurpose!.id == event.target
            ? seasonPurpose!.forPhotoId ?? 1
            : inProcessPurposes
                .where((element) => element.purpose.id == event.target)
                .first
                .id));
    PurposeState state = gotPurpose.fold((error) => errorCheck(error), (data) {
      clearAll();
      return CompletedPurposeState();
    });
    emit(state);
  }

  void _sendPhotoPurpose(
      SendPhotoPurposeEvent event, Emitter<PurposeState> emit) async {
    print('COMPLETE PURPOSE DATA');
    emit(PurposeLoadingState());

    //Send photo of purpose and complete)(history)
    final gotPurpose = await sendPhotoPurpose.call(SendPhotoPurposeParams(
        path: event.path,
        target: seasonPurpose!.id == event.target
            ? seasonPurpose!.forPhotoId ?? 1
            : inProcessPurposes
                .where((element) => element.purpose.id == event.target)
                .first
                .id));
    PurposeState state = gotPurpose.fold((error) => errorCheck(error), (data) {
      clearAll();
      return CompletedPurposeState();
    });
    emit(state);
  }

  PurposeState errorCheck(Failure failure) {
    print('FAIL: $failure');
    if (failure == ConnectionFailure() || failure == NetworkFailure()) {
      return PurposeInternetErrorState();
    } else if (failure is ServerFailure) {
      if (failure.message == 'token_error') {
        print('token_error');
        return PurposeErrorState(
            message: failure.message.length < 100
                ? failure.message
                : 'Вы не авторизованы',
            isTokenError: true);
      }
      return PurposeErrorState(
          message:
              failure.message.length < 100 ? failure.message : 'Ошибка сервера',
          isTokenError: false);
    } else {
      return PurposeErrorState(
          message: 'Повторите попытку', isTokenError: false);
    }
  }

  void clearAll() {
    seasonPurpose = null;
    allPurposes = [];
    availablePurposes = [];
    inProcessPurposes = [];
    historyPurposes = [];
  }

  List<PurposeEntity> getPurposeListFromFullData(List<FullPurposeEntity> list,
      {bool isHistory = false}) {
    List<PurposeEntity> result = [];
    for (var item in list) {
      if (isHistory) {
        item.purpose.inHistory = true;
      } else {
        item.purpose.inProcess = true;
      }
      result.add(item.purpose);
    }
    return result;
  }

  getCurrentLocation() {
    // LocationPermission permission = await Geolocator.checkPermission();
    //   bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    //   if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever || !isLocationEnabled){
    //     permission = await Geolocator.requestPermission();
    //   }
    //   if(permission != LocationPermission.denied && permission != LocationPermission.deniedForever){
    //     if(isLocationEnabled){
    //       setState(() {
    //         isSelectedCurrentPosition = true;
    //       });
    //       Position _position = await Geolocator.getCurrentPosition();
    //       currentPosition = LatLng(_position.latitude, _position.longitude);
    //       findPlace(_position.latitude, _position.longitude);

    //       if(MainConfigApp.mapKitUsed == MapKitUsed.yandex){
    //         yandexMapController!.moveCamera(
    //           yandexMap.CameraUpdate.newCameraPosition(
    //             yandexMap.CameraPosition(target: yandexMap.Point(latitude: _position.latitude, longitude: _position.longitude))
    //           )
    //         );
    //       }else{
    //         osMapController!.move(currentPosition, 15);
    //       }
    //     }
    //   }
  }
}
