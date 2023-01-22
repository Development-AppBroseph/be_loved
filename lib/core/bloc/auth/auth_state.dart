part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthStated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthIdle extends AuthState {}

class PhoneError extends AuthState {
  String error;

  PhoneError(this.error);
}
class VKError extends AuthState {
  String error;

  VKError(this.error);
}
class VKLoggin extends AuthState {
  String code;
  String token;

  VKLoggin({required this.token, required this.code});
}
class VKRequiredRegister extends AuthState {
  String code;
  VKRequiredRegister({required this.code});
}

class PhoneSuccess extends AuthState {
  String phone;
  int code;

  PhoneSuccess(this.phone, this.code);
}

class CodeError extends AuthState {
  String error;

  CodeError(this.error);
}

class CodeSuccess extends AuthState {
  ExistUser existUser;
  String token;

  CodeSuccess(this.existUser, this.token);
}

class NicknameError extends AuthState {
  String error;

  NicknameError(this.error);
}

class NicknameSuccess extends AuthState {
  bool exist;

  NicknameSuccess(this.exist);
}

class ImageError extends AuthState {}

class ImageSuccess extends AuthState {
  XFile image;

  ImageSuccess(this.image);
}

class InitSuccess extends AuthState {
  String token;

  InitSuccess(this.token);
}

class InitError extends AuthState {
  String error;

  InitError(this.error);
}

class GetUserSuccess extends AuthState {
  UserAnswer user;

  GetUserSuccess(this.user);
}

class GetUserError extends AuthState {}

class InviteSuccess extends AuthState {}

class InviteError extends AuthState {
  String error;

  InviteError(this.error);
}

class InviteError400 extends AuthState {
  String error;

  InviteError400(this.error);
}

class DeleteInviteSuccess extends AuthState {}

class DeleteInviteError extends AuthState {}

class ReceiveInvite extends AuthState {}

// class InviteAccepted extends AuthState {
//   bool fromYou;

//   InviteAccepted(this.fromYou);
// }

class ReletionshipsStarted extends AuthState {}

class ReletionshipsError extends AuthState {}

class ReletionshipsAccepted extends AuthState {}

class ReletionshipsAcceptedError extends AuthState {}

class TextFieldSuccess extends AuthState {}

class TextFieldError extends AuthState {}

class CheckIsUserExistSuccess extends AuthState {}

class CheckIsUserExistError extends AuthState {}

class RefreshUser extends AuthState {}
