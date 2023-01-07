import 'dart:io';
import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_group_files_entity.dart';
import 'package:be_loved/features/home/domain/usecases/add_gallery_file.dart';
import 'package:be_loved/features/home/domain/usecases/delete_gallery_files.dart';
import 'package:be_loved/features/home/domain/usecases/get_gallery_files.dart';
import 'package:be_loved/features/home/presentation/views/archive/helpers/video_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'gallery_event.dart';
part 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GetGalleryFiles getGalleryFiles;
  final AddGalleryFile addGalleryFile;
  final DeleteGalleryFiles deleteGalleryFiles;

  GalleryBloc(this.addGalleryFile, this.getGalleryFiles, this.deleteGalleryFiles)
      : super(GalleryFilesInitialState()) {
    on<GetGalleryFilesEvent>(_getGallery);
    on<GalleryFileAddEvent>(_addGallery);
    // on<GalleryFileEditEvent>(_editGallery);
    on<GalleryFileDeleteEvent>(_deleteGalleryFile);
  }

  List<GalleryFileEntity> files = [];
  List<GalleryGroupFilesEntity> groupedFiles = [];
  int page = 0;
  bool isLoading = false;
  bool isEnd = false;

  void _getGallery(
      GetGalleryFilesEvent event, Emitter<GalleryState> emit) async {
    print('GET GALLERY FILES BLOC page: ${page}; isEnd: ${isEnd}');
    isLoading = true;
    if (event.isReset) {
      emit(GalleryFilesLoadingState());
      page = 0;
      isEnd = false;
      files = [];
    }else{
      emit(GalleryFilesBlankState());
    }
    page++;
    final gotGallery = await getGalleryFiles.call(page);
    GalleryState state = gotGallery.fold(
      (error) => errorCheck(error),
      (data) {
        print('DATA GOT: ${data}');
        if(data.any((element) => files.any((file) => file.id == element.id))){
          isEnd = true;
        }else{
          if (event.isReset) {
            files = data;
          } else {
            files.addAll(data);
          }
          groupedFiles = getGroupedFiles(files);
        }
        return GotSuccessGalleryState();
      },
    );
    isLoading = false;
    emit(state);
  }

  void _addGallery(
      GalleryFileAddEvent event, Emitter<GalleryState> emit) async {
    emit(GalleryFilesLoadingState());
    final data = await addGalleryFile.call(AddGalleryFileParams(
        galleryFileEntity: event.galleryFileEntity, ));
    GalleryState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        return GalleryFilesAddedState();
      },
    );
    emit(state);
  }

  // void _editGallery(GalleryFileEditEvent event, Emitter<GalleryState> emit) async {
  //   emit(GalleryFileLoadingState());
  //   final data = await editGalleryFile.call(EditGalleryFileParams(tagEntity: event.tagEntity));
  //   GalleryState state = data.fold(
  //     (error) => errorCheck(error),
  //     (data) {
  //       tags.removeWhere(((element) => element.id == event.tagEntity.id));
  //       tags = tags.reversed.toList();
  //       tags.add(data);
  //       tags = tags.reversed.toList();
  //       return GalleryFileAddedState(tagEntity: data);
  //     },
  //   );
  //   emit(state);
  // }

  void _deleteGalleryFile(GalleryFileDeleteEvent event, Emitter<GalleryState> emit) async {
    emit(GalleryFilesBlankState());
    final data = await deleteGalleryFiles.call(event.ids);
    GalleryState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        return GalleryFilesDeletedState();
      },
    );
    emit(state);
  }

  GalleryState errorCheck(Failure failure) {
    print('FAIL: $failure');
    if (failure == ConnectionFailure() || failure == NetworkFailure()) {
      return GalleryFilesInternetErrorState();
    } else if (failure is ServerFailure) {
      if (failure.message == 'token_error') {
        print('token_error');
        return GalleryFilesErrorState(
            message: failure.message.length < 100
                ? failure.message
                : 'Вы не авторизованы',
            isTokenError: true);
      }
      return GalleryFilesErrorState(
          message:
              failure.message.length < 100 ? failure.message : 'Ошибка сервера',
          isTokenError: false);
    } else {
      return GalleryFilesErrorState(
          message: 'Повторите попытку', isTokenError: false);
    }
  }

  List<GalleryGroupFilesEntity> getGroupedFiles(List<GalleryFileEntity> list) {
    List<GalleryGroupFilesEntity> listItems = [];

    for (int i = 0; i < list.length; i++) {
      //FIrst file(first group)
      if (i == 0) {
        listItems.add(GalleryGroupFilesEntity(
            mainPhoto: list[i],
            mainVideo: null,
            additionalFiles: [],
            startDate: list[i].dateTime,
            toDate: null));
      }

      if (i != 0) {
        bool isAdded = false;
        for (GalleryGroupFilesEntity gItem in listItems) {
          //Files in 3 days
          if (!isAdded &&
              gItem.startDate
                      .add(const Duration(days: 3))
                      .millisecondsSinceEpoch >
                  list[i].dateTime.millisecondsSinceEpoch) {
            //If video file
            if (listItems[listItems.indexOf(gItem)].additionalFiles.isEmpty &&
                checkIsVideo(list[i].urlToFile)) {
              listItems[listItems.indexOf(gItem)].mainVideo = list[i];
            } else {
              listItems[listItems.indexOf(gItem)].additionalFiles.add(list[i]);
            }
            isAdded = true;
            break;
          }
        }
        if (!isAdded) {
          listItems.add(GalleryGroupFilesEntity(
              mainPhoto: list[i],
              mainVideo: null,
              additionalFiles: [],
              startDate: list[i].dateTime,
              toDate: null));
        }
      }
    }

    return listItems;
  }
}
