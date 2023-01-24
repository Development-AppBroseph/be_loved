part of 'moments_bloc.dart';


abstract class MomentsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class GetMomentsEvent extends MomentsEvent{
  final bool isReset;
  GetMomentsEvent({this.isReset = false});
}


class AddFavoritesFileEvent extends MomentsEvent{
  final int id;
  AddFavoritesFileEvent({required this.id});
}

// class DeleteMomentEvent extends MomentsEvent{
//   final MomentEntity MomentEntity;
//   DeleteMomentEvent({required this.MomentEntity});
// }
