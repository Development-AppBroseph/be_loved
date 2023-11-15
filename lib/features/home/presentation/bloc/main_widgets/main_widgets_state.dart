part of 'main_widgets_bloc.dart';

abstract class MainWidgetsState extends Equatable {
  const MainWidgetsState();
  @override
  List<Object> get props => [];
}

class MainWidgetsInitialState extends MainWidgetsState {}

class MainWidgetsLoadingState extends MainWidgetsState {}

class MainWidgetsErrorState extends MainWidgetsState {
  final String message;
  MainWidgetsErrorState({required this.message});
}

class MainWidgetsInternetErrorState extends MainWidgetsState {}

class GotSuccessMainWidgetsState extends MainWidgetsState {}

class MainWidgetsBlankState extends MainWidgetsState {}

// ignore: must_be_immutable
class MainWidgetsAddedState extends MainWidgetsState {
  bool isRefresh;
  MainWidgetsAddedState({this.isRefresh = false});
}

class MainWidgetsDeletedState extends MainWidgetsState {}
