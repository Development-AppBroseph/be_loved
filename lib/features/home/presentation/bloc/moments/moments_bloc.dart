import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/utils/helpers/date_time_helper.dart';
import 'package:be_loved/features/home/domain/entities/archive/album_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/moment_entity.dart';
import 'package:be_loved/features/home/domain/usecases/add_favorites.dart';
import 'package:be_loved/features/home/domain/usecases/get_moments.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
part 'moments_event.dart';
part 'moments_state.dart';

class MomentsBloc extends Bloc<MomentsEvent, MomentsState> {
  GetMoments getMoments;
  AddFavorites addFavorites;

  MomentsBloc(this.getMoments, this.addFavorites)
      : super(MomentInitialState()) {
    on<GetMomentsEvent>(_getMoments);
    on<AddFavoritesFileEvent>(_addFavorites);
    // on<DeleteMomentEvent>(_deleteMoment);
  }

  MomentEntity moments = MomentEntity(
    forYou: const [],
    otherFiles: const [],
    groupedOtherFiles: const [],
    targets: const [],
  );

  int page = 0;
  bool isLoading = false;
  bool isEnd = false;

  void _getMoments(GetMomentsEvent event, Emitter<MomentsState> emit) async {
    //pagination
    isLoading = true;
    if (event.isReset) {
      emit(MomentLoadingState());
      page = 0;
      isEnd = false;
      moments = MomentEntity(
          forYou: const [],
          otherFiles: const [],
          groupedOtherFiles: const [],
          targets: const []);
    } else {
      emit(MomentBlankState());
    }
    page++;
    print('MOMENTS GET PAGE: $page');

    final gotMoments = await getMoments.call(page);
    MomentsState state = gotMoments.fold(
      (error) => errorCheck(error),
      (data) {
        //pagination
        if (data.otherFiles.any((element) =>
            moments.otherFiles.any((file) => file.id == element.id))) {
          isEnd = true;
        } else {
          if (event.isReset) {
            moments = MomentEntity(
              forYou: data.forYou,
              otherFiles: data.otherFiles,
              groupedOtherFiles: getGroupedFiles(data.otherFiles),
              targets: data.targets,
            );
          } else {
            moments = MomentEntity(
              forYou: data.forYou,
              otherFiles: [...moments.otherFiles, ...data.otherFiles],
              groupedOtherFiles: const [],
              targets: data.targets,
            );
            moments.groupedOtherFiles = getGroupedFiles(moments.otherFiles);
          }
        }

        // moments = MomentEntity(
        //   forYou: data.forYou,
        //   otherFiles: data.otherFiles,
        //   groupedOtherFiles: getGroupedFiles(data.otherFiles)
        // );
        return GotSuccessMomentsState();
      },
    );
    isLoading = false;
    emit(state);
  }

  void _addFavorites(
      AddFavoritesFileEvent event, Emitter<MomentsState> emit) async {
    emit(MomentBlankState());
    final data = await addFavorites.call(AddFavoritesParams(
        fileId: event.id, isFavor: setNewFavorite(event.id)));
    MomentsState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        return MomentFavoriteChangeState();
      },
    );
    emit(MomentFavoriteChangeState());
  }

  MomentsState errorCheck(Failure failure) {
    print('FAIL: $failure');
    if (failure == ConnectionFailure() || failure == NetworkFailure()) {
      return MomentInternetErrorState();
    } else if (failure is ServerFailure) {
      return MomentErrorState(
          message: failure.message.length < 100
              ? failure.message
              : 'Ошибка сервера');
    } else {
      return MomentErrorState(message: 'Повторите попытку');
    }
  }

  List<AlbumEntity> getGroupedFiles(List<GalleryFileEntity> list) {
    List<AlbumEntity> listItems = [];

    DateTime dateTime = DateTime.now();
    for (int i = 0; i < list.length; i++) {
      if (i == 0) {
        listItems.add(
          AlbumEntity(
            id: 0,
            relationId: 0,
            name: DateFormat('dd.MM.yyyy').format(list[i].dateTime),
            files: [list[i]],
          ),
        );
        dateTime = list[i].dateTime;
      }

      if (i != 0) {
        if (isOneDay(list[i].dateTime, dateTime)) {
          listItems[listItems.length - 1].files.add(list[i]);
        } else {
          listItems.add(
            AlbumEntity(
              id: 0,
              relationId: 0,
              name: DateFormat('dd.MM.yyyy').format(list[i].dateTime),
              files: [list[i]],
            ),
          );
          dateTime = list[i].dateTime;
        }
      }
    }
    return listItems;
  }

  bool setNewFavorite(int id) {
    bool isSet = false;
    bool newValue = false;
    for (int i = 0; i < moments.forYou.length; i++) {
      if (moments.forYou[i].id == id) {
        newValue = !moments.forYou[i].isFavorite;
        moments.forYou[i].isFavorite = !moments.forYou[i].isFavorite;
      } else {
        newValue = !moments.targets[i].isFavorite;
        moments.targets[i].isFavorite = !moments.targets[i].isFavorite;
      }
    }
    if (!isSet) {
      for (int i = 0; i < moments.otherFiles.length; i++) {
        if (moments.otherFiles[i].id == id) {
          newValue = !moments.otherFiles[i].isFavorite;
          moments.otherFiles[i].isFavorite = !moments.otherFiles[i].isFavorite;
        }
      }
      moments.groupedOtherFiles = getGroupedFiles(moments.otherFiles);
    }

    return newValue;
  }
}
