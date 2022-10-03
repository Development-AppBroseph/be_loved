part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthStated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthIdle extends AuthState {}

class PhoneError extends AuthState {}

class PhoneSuccess extends AuthState {
  String phone;
  int code;

  PhoneSuccess(this.phone, this.code);
}

class CodeError extends AuthState {}

class CodeSuccess extends AuthState {
  ExistUser existUser;
  String token;

  CodeSuccess(this.existUser, this.token);
}

class NicknameError extends AuthState {}

class NicknameSuccess extends AuthState {
  bool exist;
  NicknameSuccess(this.exist);
}

class ImageError extends AuthState {}

class ImageSuccess extends AuthState {
  XFile image;

  ImageSuccess(this.image);
}

class InitSuccess extends AuthState {}

class InitError extends AuthState {}

class GetUserSuccess extends AuthState {
  UserAnswer user;

  GetUserSuccess(this.user);
}

class GetUserError extends AuthState {}

class InviteSuccess extends AuthState {}

class InviteError extends AuthState {}

class DeleteInviteSuccess extends AuthState {}

class DeleteInviteError extends AuthState {}

class ReceiveInvite extends AuthState {}

class InviteAccepted extends AuthState {
  bool fromYou;

  InviteAccepted(this.fromYou);
}

class ReletionshipsStarted extends AuthState {}

class ReletionshipsError extends AuthState {}

class ReletionshipsAccepted extends AuthState {}

class ReletionshipsAcceptedError extends AuthState {}
