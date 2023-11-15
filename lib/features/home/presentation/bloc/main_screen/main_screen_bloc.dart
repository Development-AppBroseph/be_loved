import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
part 'main_screen_event.dart';
part 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc()
      : super(MainScreenChangedState(currentView: 0, currentWidget: null)) {
    on<ChangeViewEvent>(_changeView);
    on<SetStateEvent>(_setState);
  }

  int currentView = 0;
  Widget? currentWidget = null;

  void _changeView(ChangeViewEvent event, Emitter<MainScreenState> emit) async {
    emit(MainScreenBlankState());
    if (event.view != null) {
      currentView = event.view!;
      currentWidget = null;
    } else {
      currentWidget = event.widget;
    }
    emit(MainScreenChangedState(
        currentView: currentView, currentWidget: currentWidget));
  }

  void _setState(SetStateEvent event, Emitter<MainScreenState> emit) async {
    emit(MainScreenBlankState());

    emit(MainScreenSetStateState());
  }
}
