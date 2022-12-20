part of 'gallery_bloc.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();
  @override
  List<Object> get props => [];
}

class GalleryFilesInitialState extends GalleryState {}
class GalleryFilesLoadingState extends GalleryState {}
class GalleryFilesErrorState extends GalleryState {
  final bool isTokenError;
  final String message;
  GalleryFilesErrorState({required this.message, required this.isTokenError});
}
class GalleryFilesInternetErrorState extends GalleryState{}

class GotSuccessGalleryState extends GalleryState{}
class GalleryFilesBlankState extends GalleryState{}
class GalleryFilesAddedState extends GalleryState{
  final GalleryFileEntity galleryFileEntity;
  GalleryFilesAddedState({required this.galleryFileEntity});
}
class GalleryFilesDeletedState extends GalleryState{}
