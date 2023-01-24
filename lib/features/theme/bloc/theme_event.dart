part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SetThemeEvent extends ThemeEvent{
  final int index;
  SetThemeEvent({required this.index});
}

class UpdateThemeEvent extends ThemeEvent{
  final int index;
  UpdateThemeEvent({required this.index});
}

class GetThemeLocalEvent extends ThemeEvent{
}