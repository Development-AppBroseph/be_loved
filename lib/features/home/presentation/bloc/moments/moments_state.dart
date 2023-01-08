part of 'moments_bloc.dart';

abstract class MomentsState extends Equatable {
  const MomentsState();
  @override
  List<Object> get props => [];
}

class MomentInitialState extends MomentsState {}
class MomentLoadingState extends MomentsState {}
class MomentErrorState extends MomentsState {
  final String message;
  MomentErrorState({required this.message});
}
class MomentInternetErrorState extends MomentsState{}

class GotSuccessMomentsState extends MomentsState{}
class MomentBlankState extends MomentsState{}
class MomentDeletedState extends MomentsState{}
class MomentFavoriteChangeState extends MomentsState{}
