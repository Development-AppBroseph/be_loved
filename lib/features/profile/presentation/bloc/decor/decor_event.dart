part of 'decor_bloc.dart';

abstract class DecorEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetBackgroundEvent extends DecorEvent{
}

class EditBackgroundEvent extends DecorEvent{
  final BackFileEntity? backFileEntity;
  final int assetPhoto;
  EditBackgroundEvent({this.backFileEntity, this.assetPhoto = 0});
}

class AddBackgroundEvent extends DecorEvent{
  final String path;
  AddBackgroundEvent({required this.path});
}
