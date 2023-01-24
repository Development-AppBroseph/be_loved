part of 'decor_bloc.dart';

abstract class DecorState extends Equatable {
  const DecorState();
  @override
  List<Object> get props => [];
}

class DecorInitialState extends DecorState {}
class DecorLoadingState extends DecorState {}
class DecorErrorState extends DecorState {
  final String message;
  DecorErrorState({required this.message});
}
class DecorInternetErrorState extends DecorState{}

class DecorBlankState extends DecorState{}
class DecorEditedSuccessState extends DecorState{}
class DecorGotSuccessState extends DecorState{}
