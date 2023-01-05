import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/entities/archive/album_entity.dart';
import 'package:be_loved/features/home/domain/usecases/create_album.dart';
import 'package:be_loved/features/home/domain/usecases/delete_album.dart';
import 'package:be_loved/features/home/domain/usecases/get_albums.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'albums_event.dart';
part 'albums_state.dart';

class AlbumsBloc extends Bloc<AlbumsEvent, AlbumsState> {
  GetAlbums getAlbums;
  CreateAlbum createAlbum;
  DeleteAlbum deleteAlbum;

  AlbumsBloc(this.getAlbums, this.createAlbum, this.deleteAlbum) : super(AlbumInitialState()) {
    on<GetAlbumsEvent>(_getAlbums);
    on<AlbumAddEvent>(_addAlbums);
    on<DeleteAlbumEvent>(_deleteAlbum);
  }

  List<AlbumEntity> albums = [];

  void _getAlbums(GetAlbumsEvent event, Emitter<AlbumsState> emit) async {
    emit(AlbumLoadingState());
    final gotAlbums = await getAlbums.call(NoParams());
    await Future.delayed(Duration(seconds: 3));
    AlbumsState state = gotAlbums.fold(
      (error) => errorCheck(error),
      (data) {
        albums = data.where((element) => element.files.isNotEmpty).toList();
        return GotSuccessAlbumsState();
      },
    );
    emit(state);
  }



  void _addAlbums(AlbumAddEvent event, Emitter<AlbumsState> emit) async {
    emit(AlbumLoadingState());
    final data = await createAlbum.call(CreateAlbumParams(albumEntity: event.albumEntity));
    AlbumsState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        return AlbumAddedState();
      },
    );
    emit(state);
  }




  void _deleteAlbum(DeleteAlbumEvent event, Emitter<AlbumsState> emit) async {
    emit(AlbumLoadingState());
    final data = await deleteAlbum.call(DeleteAlbumParams(albumEntity: event.albumEntity));
    AlbumsState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        return AlbumDeletedState();
      },
    );
    emit(state);
  }


  AlbumsState errorCheck(Failure failure){
    print('FAIL: $failure');
    if(failure == ConnectionFailure() || failure == NetworkFailure()){
      return AlbumInternetErrorState();
    }else if(failure is ServerFailure){
      return AlbumErrorState(message: failure.message.length < 100 ? failure.message : 'Ошибка сервера');
    }else{
      return AlbumErrorState(message: 'Повторите попытку');
    }
  }
} 
