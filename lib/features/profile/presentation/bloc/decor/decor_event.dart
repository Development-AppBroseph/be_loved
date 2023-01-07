part of 'decor_bloc.dart';

abstract class DecorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetBackgroundEvent extends DecorEvent{
}

class EditBackgroundEvent extends DecorEvent{
  final int index;
  EditBackgroundEvent({required this.index});
}

class AddBackgroundEvent extends DecorEvent{
  final String path;
  AddBackgroundEvent({required this.path});
}
