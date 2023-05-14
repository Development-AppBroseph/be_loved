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
  const PurposeErrorState({required this.message, required this.isTokenError});
}

class PurposeInternetErrorState extends PurposeState {
  
}

class GotPurposeDataState extends PurposeState {
  final List<PurposeEntity> allPurposes;
  final PurposeEntity? seasonPurpose;
  final List<PurposeEntity> availablePurposes;
  final List<FullPurposeEntity> inProcessPurposes;
  final List<FullPurposeEntity> historyPurposes;
  final List<PromosEntiti> promos;
  final List<ActualEntiti> actual;
  const GotPurposeDataState({
    required this.allPurposes,
    this.seasonPurpose,
    required this.availablePurposes,
    required this.inProcessPurposes,
    required this.historyPurposes,
    required this.promos,
    required this.actual,
  });
}

class PurposeBlankState extends PurposeState {}

class CompletedPurposeState extends PurposeState {}
