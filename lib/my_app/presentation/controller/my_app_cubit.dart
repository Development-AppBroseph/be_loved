import 'dart:io';

import 'package:be_loved/my_app/data/datasource.dart';
import 'package:be_loved/my_app/presentation/controller/my_app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MyAppCubit extends Cubit<MyAppState> {
  final Datasource datasource = Datasource();
  MyAppCubit() : super(MyAppEmptyState());
  Future<void> getImage() async {
    try {
      emit(MyAppLaodingState());
      final image = await datasource.initialPhoto();
      emit(MyAppLoadedState(image: image));
      Future.delayed(const Duration(seconds: 5))
          .then((value) => emit(MyAppGotoState()));
    } catch (error) {
      emit(MyAppErrorState(error: error.toString()));
    }
  }
}

class MyAppStatusCubit extends Cubit<MyAppStatusState> {
  final Datasource datasource = Datasource();

  MyAppStatusCubit() : super(MyAppEmptyStatusState());
  Future<void> getStatus() async {
    try {
      emit(MyAppEmptyStatusState());
      final info = await PackageInfo.fromPlatform();
      final status = await datasource.getVersion();
      if (Platform.isIOS) {
        if (status.version != null) {
          if (status.version != info.version) {
            emit(
              MyAppHaveUpdateState(
                apple: 'https://apps.apple.com/us/app/beloved/id6443919068',
              ),
            );
          }
        }
      } else {
        if (status.version != null) {
          if (status.version != info.version) {
            emit(
              MyAppHaveUpdateState(
                android:
                    'https://play.google.com/store/apps/details?id=dev.broseph.belovedapp',
              ),
            );
          }
        }
      }
    } catch (e) {
      emit(MyAppEmptyStatusState());
    }
  }
}
