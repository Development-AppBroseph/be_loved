import 'dart:io';

import 'package:be_loved/my_app/data/datasource.dart';
import 'package:be_loved/my_app/presentation/controller/my_app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:new_version/new_version.dart';

class MyAppCubit extends Cubit<MyAppState> {
  final Datasource datasource = Datasource();
  MyAppCubit() : super(MyAppEmptyState());
  Future<void> getImage() async {
    try {
      emit(MyAppLaodingState());
      final image = await datasource.initialPhoto();
      emit(MyAppLoadedState(image: image));
      Future.delayed(const Duration(seconds: 3))
          .then((value) => emit(MyAppGotoState()));
    } catch (error) {
      emit(MyAppErrorState(error: error.toString()));
    }
  }
}

class MyAppStatusCubit extends Cubit<MyAppStatusState> {
  MyAppStatusCubit() : super(MyAppEmptyStatusState());
  Future<void> getStatus() async {
    try {
      emit(MyAppEmptyStatusState());

      if (Platform.isIOS) {
        final newVersion = NewVersion();
        final status = await newVersion.getVersionStatus();
        if (status != null) {
          emit(MyAppHaveUpdateState(apple: status.appStoreLink));
        }
      } else {
        InAppUpdate.checkForUpdate().then((info) {
          if (info.updateAvailability == UpdateAvailability.updateAvailable) {
            emit(MyAppHaveUpdateState());
          }
        }).catchError((e) {
          emit(MyAppEmptyStatusState());
        });
      }
    } catch (e) {
      emit(MyAppEmptyStatusState());
    }
  }
}
