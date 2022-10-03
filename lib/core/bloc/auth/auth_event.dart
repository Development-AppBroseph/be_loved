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

class CheckNickname extends AuthEvent {
  String nickname;

  CheckNickname(this.nickname);
}

class GetUser extends AuthEvent {}

class SearchUser extends AuthEvent {}

class PickImage extends AuthEvent {}

class InitUser extends AuthEvent {}

class InviteUser extends AuthEvent {
  String nickname;

  InviteUser(this.nickname);
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
