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


//VK
class ConnectVKEvent extends ProfileEvent{
  final String code;
  ConnectVKEvent({required this.code});
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
  final String? date;
  EditRelationNameEvent({required this.name, this.date});
}



class PartingOrSendFilesEvent extends ProfileEvent{
  final String email;
  final bool isParting;
  PartingOrSendFilesEvent({required this.email, this.isParting = false});
}