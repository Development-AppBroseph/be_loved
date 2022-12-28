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
class CancelPurposeEvent extends PurposeEvent{
  final int target;
  CancelPurposeEvent({required this.target});
}

class SendPhotoPurposeEvent extends PurposeEvent{
  final String path;
  final int target;
  SendPhotoPurposeEvent({required this.path, required this.target});
}