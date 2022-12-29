part of 'gallery_bloc.dart';

abstract class GalleryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class GetGalleryFilesEvent extends GalleryEvent{
  bool isReset;
  GetGalleryFilesEvent({required this.isReset});
}

class GalleryFileAddEvent extends GalleryEvent{
  final List<GalleryFileEntity> galleryFileEntity;
  GalleryFileAddEvent({required this.galleryFileEntity,});
}

class GalleryFileEditEvent extends GalleryEvent{
  final GalleryFileEntity galleryFileEntity;
  GalleryFileEditEvent({required this.galleryFileEntity});
}

class GalleryFileDeleteEvent extends GalleryEvent{
  final int id;
  GalleryFileDeleteEvent({required this.id});
}