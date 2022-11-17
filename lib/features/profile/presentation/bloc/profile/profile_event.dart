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


class PostPhoneNumberEvent extends ProfileEvent{
  final String phone;
  PostPhoneNumberEvent({required this.phone});
}




class PutUserCodeEvent extends ProfileEvent{
  final int code;
  PutUserCodeEvent({required this.code});
}




class EditRelationNameEvent extends ProfileEvent{
  final String name;
  EditRelationNameEvent({required this.name});
}