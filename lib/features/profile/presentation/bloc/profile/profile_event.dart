part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}


class EditProfileEvent extends ProfileEvent{
  final User user;
  final File? avatar;
  EditProfileEvent({required this.user, required this.avatar});
}
