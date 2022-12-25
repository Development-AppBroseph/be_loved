part of 'archive_bloc.dart';

abstract class ArchiveEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class GetMemoryInfoEvent extends ArchiveEvent{}
