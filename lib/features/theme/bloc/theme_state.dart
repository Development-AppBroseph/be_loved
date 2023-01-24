part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();
  @override
  List<Object> get props => [];
}

class ThemeInitialState extends ThemeState {}
class ThemeLoadingState extends ThemeState {}
class ThemeErrorState extends ThemeState {
  final String message;
  ThemeErrorState({required this.message});
}
class ThemeInternetErrorState extends ThemeState{}

class ThemeBlankState extends ThemeState{}
class ThemeEditedSuccessState extends ThemeState{
  final bool isChanges;
  ThemeEditedSuccessState({required this.isChanges});
}
