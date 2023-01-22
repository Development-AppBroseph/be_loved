part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileState {}
class ProfileLoadingState extends ProfileState {}
class ProfileErrorState extends ProfileState {
  final String message;
  ProfileErrorState({required this.message});
}
class ProfileInternetErrorState extends ProfileState{}

class ProfileBlankState extends ProfileState{}
class ProfileEditedSuccessState extends ProfileState{}
class ProfileAddedState extends ProfileState{
  final User user;
  ProfileAddedState({required this.user});
}
class ProfileSentCodeState extends ProfileState{}
class ProfileConfirmedSuccessState extends ProfileState{}
class ProfileRelationNameChangedState extends ProfileState{}
class ProfileVKConnectedState extends ProfileState{}
class FilesSentState extends ProfileState{
  final bool isParting;
  FilesSentState({required this.isParting});
}
