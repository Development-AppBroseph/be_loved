import 'package:be_loved/features/home/domain/entities/archive/album_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:equatable/equatable.dart';

class AlbumFullEntity extends Equatable {
  final List<GalleryFileEntity> favorites;
  final List<AlbumEntity> otherAlbums;

  AlbumFullEntity({
    required this.favorites,
    required this.otherAlbums,
  });


  @override
  List<Object> get props => [
    favorites,
    otherAlbums
  ];
}
