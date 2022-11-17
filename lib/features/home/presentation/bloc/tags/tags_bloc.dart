import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/entities/events/tag_entity.dart';
import 'package:be_loved/features/home/domain/usecases/add_tag.dart';
import 'package:be_loved/features/home/domain/usecases/get_tags.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'tags_event.dart';
part 'tags_state.dart';

class TagsBloc extends Bloc<TagsEvent, TagsState> {
  final GetTags getTags;
  final AddTag addTag;

  TagsBloc(this.addTag, this.getTags) : super(TagInitialState()) {
    on<GetTagsEvent>(_getTags);
    on<TagAddEvent>(_addTags);
  }

  List<TagEntity> tags = [];

  void _getTags(GetTagsEvent event, Emitter<TagsState> emit) async {
    emit(TagLoadingState());
    final gotTags = await getTags.call(NoParams());
    await Future.delayed(Duration(seconds: 3));
    TagsState state = gotTags.fold(
      (error) => errorCheck(error),
      (data) {
        tags = data;
        return GotSuccessTagsState();
      },
    );
    emit(state);
  }



  void _addTags(TagAddEvent event, Emitter<TagsState> emit) async {
    emit(TagLoadingState());
    final data = await addTag.call(AddTagParams(tagEntity: event.tagEntity));
    TagsState state = data.fold(
      (error) => errorCheck(error),
      (data) {
        tags = tags.reversed.toList();
        tags.add(data);
        tags = tags.reversed.toList();
        return TagAddedState(tagEntity: data);
      },
    );
    emit(state);
  }



  // void _deleteTag(TagDeleteEvent event, Emitter<TagsState> emit) async {
  //   emit(TagLoadingState());
  //   final data = await deleteTag.call(DeleteTagParams(ids: event.ids));
  //   TagsState state = data.fold(
  //     (error) => errorCheck(error),
  //     (data) {
  //       for(int id in event.ids){
  //         events.removeWhere((element) => element.id == id);
  //         eventsInHome.removeWhere((element) => element.id == id);
  //       }
  //       return TagDeletedState();
  //     },
  //   );
  //   emit(state);
  // }




  TagsState errorCheck(Failure failure){
    print('FAIL: $failure');
    if(failure == ConnectionFailure() || failure == NetworkFailure()){
      return TagInternetErrorState();
    }else if(failure is ServerFailure){
      if(failure.message == 'token_error'){
        print('token_error');
        return TagErrorState(message: failure.message.length < 100 ? failure.message : 'Вы не авторизованы', isTokenError: true);
      }
      return TagErrorState(message: failure.message.length < 100 ? failure.message : 'Ошибка сервера', isTokenError: false);
    }else{
      return TagErrorState(message: 'Повторите попытку', isTokenError: false);
    }
  }
} 
