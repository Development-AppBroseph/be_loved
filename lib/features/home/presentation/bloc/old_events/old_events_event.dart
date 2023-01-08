part of 'old_events_bloc.dart';


abstract class OldEventsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class GetOldEventsEvent extends OldEventsEvent{
  final bool isReset;
  GetOldEventsEvent({this.isReset = false});
}

class DeleteOldEventEvent extends OldEventsEvent{
  final int id;
  DeleteOldEventEvent({required this.id});
}
