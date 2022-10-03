// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'dart:io';
import 'package:be_loved/core/helpers/enums.dart';
import 'package:be_loved/core/network/repository.dart';
import 'package:be_loved/core/helpers/shared_prefs.dart';
import 'package:be_loved/models/user/user.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  int? code;
  String? token;
  String? secretKey;
  String? nickname;
  XFile? image;
  UserAnswer? user;

  AuthBloc() : super(AuthStated()) {
    on<SendPhone>((event, emit) => _sendPhone(event, emit));
    on<CheckUser>((event, emit) => _checkUser(event, emit));
    on<CheckNickname>((event, emit) => _checkNickname(event, emit));
    on<PickImage>((event, emit) => _pickImage(event, emit));
    on<InitUser>((event, emit) => _initUser(event, emit));
    on<GetUser>((event, emit) => _getUser(event, emit));
    on<SearchUser>((event, emit) => _searchUser(event, emit));
    on<InviteUser>((event, emit) => _inviteUser(event, emit));
    on<DeleteInviteUser>((event, emit) => _deleteInviteUser(event, emit));
    on<StartRelationships>((event, emit) => _startRelationShips(event, emit));
    on<AcceptReletionships>((event, emit) => _acceptInviteUser(event, emit));
    on<LogOut>((event, emit) => _logOut(event, emit));
  }

  void _sendPhone(SendPhone state, Emitter<AuthState> emit) async {
    user = null;
    token = null;
    secretKey = null;
    emit(AuthLoading());
    var result = await Repository().registration(state.phone);

    if (result != null) {
      code = result;
      emit(PhoneSuccess(state.phone, result));
    } else {
      emit(PhoneError());
    }
  }

  void _checkUser(CheckUser state, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    var result = await Repository().checkIsUserExist(state.phone, state.code);

    if (result != null) {
      if (result.token != null) {
        await SharedPreferences.getInstance()
          ..setString('token', result.token!);
        token = result.token;
      }
      secretKey = result.secretKey;
      emit(
        CodeSuccess(
          result.token != null ? ExistUser.exist : ExistUser.notExist,
          result.token != null ? result.token! : result.secretKey!,
        ),
      );
    } else {
      emit(CodeError());
    }
  }

  void _checkNickname(CheckNickname state, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    nickname = state.nickname;
    var result = await Repository().checkNickName(state.nickname);

    if (result != null) {
      // print(result);
      emit(NicknameSuccess(result));
    } else {
      emit(NicknameError());
    }
  }

  void _pickImage(PickImage state, Emitter<AuthState> emit) async {
    var result = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (result != null) {
      emit(ImageSuccess(result));
      image = result;
    } else {
      emit(ImageError());
    }
  }

  void _initUser(InitUser state, Emitter<AuthState> emit) async {
    var file = File(image!.path);
    final filePath = file.absolute.path;

    final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
    emit(AuthLoading());
    var compressedImage = await FlutterImageCompress.compressAndGetFile(
      file.path,
      outPath,
      quality: 30,
    );

    var result = await Repository()
        .initUser(secretKey ?? '', nickname ?? '', compressedImage);

    if (result != null) {
      token = result;
      await SharedPreferences.getInstance()
        ..setString('token', result);
      emit(InitSuccess());
    } else {
      emit(InitError());
    }
  }

  void _getUser(GetUser state, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    var result = await Repository().getUser();

    if (result != null) {
      user = result;
      emit(GetUserSuccess(result));
    } else {
      emit(GetUserError());
    }
  }

  void _searchUser(SearchUser state, Emitter<AuthState> emit) async {
    // emit(AuthLoading());
    var result = await Repository().getUser();

    if (result != null) {
      user = result;

      if (result.status != 'Принято') {
        if (result.fromYou != null) {
          if (!result.fromYou!) {
            emit(ReceiveInvite());
          }
        } else {
          emit(GetUserSuccess(result));
        }
      } else {
        if (result.date == null) {
          emit(InviteAccepted(result.fromYou!));
        } else {
          MySharedPrefs().setUser(token!, result);
          emit(ReletionshipsStarted());
        }
      }
      // print('huy');
    } else {
      emit(GetUserError());
    }
  }

  void _inviteUser(InviteUser state, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    var result = await Repository().inviteUser(state.nickname);

    if (result != null) {
      user = result;
      emit(InviteSuccess());
    } else {
      emit(InviteError());
    }
  }

  void _deleteInviteUser(
      DeleteInviteUser state, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    var result = await Repository().deleteInviteUser(user!.relationId!);

    if (result != null) {
      user = result;
      emit(DeleteInviteSuccess());
    } else {
      emit(DeleteInviteError());
    }
  }

  void _startRelationShips(
      StartRelationships state, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    var result =
        await Repository().startRelationships(state.date, user!.relationId!);

    if (result != null) {
      MySharedPrefs().setUser(token!, result);
      user = result;
      emit(ReletionshipsStarted());
    } else {
      emit(ReletionshipsError());
    }
  }

  void _acceptInviteUser(
      AcceptReletionships state, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    var result = await Repository().acceptRelationships(user!.relationId!);

    if (result != null) {
      user = result;
      emit(ReletionshipsAccepted());
    } else {
      emit(ReletionshipsAcceptedError());
    }
  }

  void _logOut(LogOut state, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Repository().deleteInviteUser(
        ((await MySharedPrefs().user) as UserAnswer).relationId!);
    // ignore: use_build_context_synchronously
    MySharedPrefs().logOut(state.context);
    emit(AuthStated());
  }
}
