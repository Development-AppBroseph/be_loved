part of 'albums_bloc.dart';

abstract class AlbumsState extends Equatable {
  const AlbumsState();
  @override
  List<Object> get props => [];
}

class AlbumInitialState extends AlbumsState {}
class AlbumLoadingState extends AlbumsState {}
class AlbumErrorState extends AlbumsState {
  final String message;
  AlbumErrorState({required this.message});
}
class AlbumInternetErrorState extends AlbumsState{}

class GotSuccessAlbumsState extends AlbumsState{}
class AlbumBlankState extends AlbumsState{}
class AlbumAddedState extends AlbumsState{
}
class AlbumDeletedState extends AlbumsState{}
