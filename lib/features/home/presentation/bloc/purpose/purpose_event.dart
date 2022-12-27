part of 'purpose_bloc.dart';

abstract class PurposeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class GetAllPurposeDataEvent extends PurposeEvent{}
class CompletePurposeEvent extends PurposeEvent{
  final int target;
  CompletePurposeEvent({required this.target});
}
