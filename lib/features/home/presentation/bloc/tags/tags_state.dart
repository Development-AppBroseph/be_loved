part of 'tags_bloc.dart';

abstract class TagsState extends Equatable {
  const TagsState();
  @override
  List<Object> get props => [];
}

class TagInitialState extends TagsState {}
class TagLoadingState extends TagsState {}
class TagErrorState extends TagsState {
  final bool isTokenError;
  final String message;
  TagErrorState({required this.message, required this.isTokenError});
}
class TagInternetErrorState extends TagsState{}

class GotSuccessTagsState extends TagsState{}
class TagBlankState extends TagsState{}
class TagAddedState extends TagsState{
  final TagEntity tagEntity;
  TagAddedState({required this.tagEntity});
}
class TagDeletedState extends TagsState{}
