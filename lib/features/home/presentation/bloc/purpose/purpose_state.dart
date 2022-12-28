part of 'purpose_bloc.dart';

abstract class PurposeState extends Equatable {
  const PurposeState();
  @override
  List<Object> get props => [];
}

class PurposeInitialState extends PurposeState {}
class PurposeLoadingState extends PurposeState {}
class PurposeErrorState extends PurposeState {
  final bool isTokenError;
  final String message;
  PurposeErrorState({required this.message, required this.isTokenError});
}
class PurposeInternetErrorState extends PurposeState{}

class GotPurposeDataState extends PurposeState{}
class PurposeBlankState extends PurposeState{}
class CompletedPurposeState extends PurposeState{}
