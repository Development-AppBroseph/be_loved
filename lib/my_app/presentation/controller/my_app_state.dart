import 'package:be_loved/my_app/models/image_model.dart';

abstract class MyAppState {}
abstract class MyAppStatusState{}

class MyAppEmptyState extends MyAppState {}

class MyAppLaodingState extends MyAppState {}

class MyAppGotoState extends MyAppState {}

class MyAppLoadedState extends MyAppState {
  final ImageModel image;
  MyAppLoadedState({required this.image});
}

class MyAppErrorState extends MyAppState {
  final String error;

  MyAppErrorState({required this.error});
}

class MyAppHaveUpdateState extends MyAppStatusState {
  final String? apple;
  final String? android;

  MyAppHaveUpdateState({this.apple, this.android});
}

class MyAppEmptyStatusState extends MyAppStatusState{

}
