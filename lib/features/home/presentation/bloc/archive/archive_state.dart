part of 'archive_bloc.dart';

abstract class ArchiveState extends Equatable {
  const ArchiveState();
  @override
  List<Object> get props => [];
}

class ArchiveInitialState extends ArchiveState {}
class ArchiveLoadingState extends ArchiveState {}
class ArchiveErrorState extends ArchiveState {
  final bool isTokenError;
  final String message;
  ArchiveErrorState({required this.message, required this.isTokenError});
}
class ArchiveInternetErrorState extends ArchiveState{}

class GotSuccessMemoryInfoState extends ArchiveState{}
class ArchiveBlankState extends ArchiveState{}
