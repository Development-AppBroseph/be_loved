part of 'albums_bloc.dart';


abstract class AlbumsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class GetAlbumsEvent extends AlbumsEvent{}

class AlbumAddEvent extends AlbumsEvent{
  final AlbumEntity albumEntity;
  AlbumAddEvent({required this.albumEntity});
}


class DeleteAlbumEvent extends AlbumsEvent{
  final AlbumEntity albumEntity;
  DeleteAlbumEvent({required this.albumEntity});
}
