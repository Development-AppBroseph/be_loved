part of 'main_screen_bloc.dart';

class MainScreenEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class ChangeViewEvent extends MainScreenEvent{
  final int? view;
  final Widget? widget;
  ChangeViewEvent({this.view, this.widget});
}
class SetStateEvent extends MainScreenEvent{}