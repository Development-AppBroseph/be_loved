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
  final GalleryFileEntity galleryFileEntity;
  final File? file;
  GalleryFileAddEvent({required this.galleryFileEntity, required this.file});
}

class GalleryFileEditEvent extends GalleryEvent{
  final GalleryFileEntity galleryFileEntity;
  GalleryFileEditEvent({required this.galleryFileEntity});
}

class GalleryFileDeleteEvent extends GalleryEvent{
  final int id;
  GalleryFileDeleteEvent({required this.id});
}