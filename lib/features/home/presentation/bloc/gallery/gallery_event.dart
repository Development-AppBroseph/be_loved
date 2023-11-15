part of 'gallery_bloc.dart';

abstract class GalleryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class GetGalleryFilesEvent extends GalleryEvent {
  bool isReset;
  GetGalleryFilesEvent({required this.isReset});
}

class GalleryFileAddEvent extends GalleryEvent {
  final List<GalleryFileEntity> galleryFileEntity;
  GalleryFileAddEvent({
    required this.galleryFileEntity,
  });
}

class GalleryFileEditEvent extends GalleryEvent {
  final GalleryFileEntity galleryFileEntity;
  GalleryFileEditEvent({required this.galleryFileEntity});
}

class GalleryFileDeleteEvent extends GalleryEvent {
  final List<int> ids;
  GalleryFileDeleteEvent({required this.ids});
}
