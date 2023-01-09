part of 'stats_bloc.dart';

abstract class StaticsState extends Equatable {
  const StaticsState();
  @override
  List<Object> get props => [];
}

class StaticsInitialState extends StaticsState {}
class StaticsLoadingState extends StaticsState {}
class StaticsErrorState extends StaticsState {
  final bool isTokenError;
  final String message;
  StaticsErrorState({required this.message, required this.isTokenError});
}
class StaticsInternetErrorState extends StaticsState{}

class GotSuccessStaticsInfoState extends StaticsState{}
class StaticsBlankState extends StaticsState{}
