part of 'auth_bloc.dart';

abstract class AuthEvent {}

class SendPhone extends AuthEvent {
  String phone;

  SendPhone(this.phone);
}

class CheckUser extends AuthEvent {
  String phone;
  int code;

  CheckUser(this.phone, this.code);
}

class SetNickname extends AuthEvent {
  String nickname;

  SetNickname(this.nickname);
}

class GetUser extends AuthEvent {}

class EditUserInfo extends AuthEvent {}

class SearchUser extends AuthEvent {}

class PickImage extends AuthEvent {}

class InitUser extends AuthEvent {}

class InviteUser extends AuthEvent {
  String phone;

  InviteUser(this.phone);
}

class DeleteInviteUser extends AuthEvent {}

class StartRelationships extends AuthEvent {
  String date;

  StartRelationships(this.date);
}

class AcceptReletionships extends AuthEvent {}

class LogOut extends AuthEvent {
  BuildContext context;

  LogOut(this.context);
}
