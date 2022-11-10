// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'dart:io';
import 'package:be_loved/core/network/repository.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/database/secure_storage.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/locator.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/database/shared_prefs.dart';
import '../../utils/enums.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  int? code;
  String? token;
  String? secretKey;
  String? nickname;
  String? phone;
  File? image;
  UserAnswer? user;

  AuthBloc() : super(AuthStated()) {
    on<SendPhone>((event, emit) => _sendPhone(event, emit));
    on<CheckUser>((event, emit) => _checkUser(event, emit));
    on<CheckIsUserPhone>((event, emit) => _checkPhoneNumber(event, emit));
    on<SetNickname>((event, emit) => _setNickname(event, emit));
    on<PickImage>((event, emit) => _pickImage(event, emit));
    on<InitUser>((event, emit) => _initUser(event, emit));
    on<GetUser>((event, emit) => _getUser(event, emit));
    // on<SearchUser>((event, emit) => _searchUser(event, emit));
    on<InviteUser>((event, emit) => _inviteUser(event, emit));
    on<DeleteInviteUser>((event, emit) => _deleteInviteUser(event, emit));
    on<StartRelationships>((event, emit) => _startRelationShips(event, emit));
    on<AcceptReletionships>((event, emit) => _acceptInviteUser(event, emit));
    on<LogOut>((event, emit) => _logOut(event, emit));
    on<EditUserInfo>((event, emit) => _editUserInfo(event, emit));
    on<TextFieldFilled>((event, emit) => _textFieldChangeState(event, emit));
  }

  void _sendPhone(SendPhone event, Emitter<AuthState> emit) async {
    user = null;
    token = null;
    secretKey = null;
    phone = event.phone;
    emit(AuthLoading());
    if (event.phone.length == 12) {
      var result = await Repository().registration(event.phone);
      if (result != null) {
        code = result;
        emit(PhoneSuccess(event.phone, result));
      } else {
        emit(PhoneError('Неверный формат номера'));
      }
    } else {
      emit(PhoneError('Введите номер телефона'));
    }
  }

  void _editUserInfo(EditUserInfo event, Emitter<AuthState> emit) async {
    var result = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    //print(result);
    if (result != null) {
      var file = File(result.path);
      final filePath = file.absolute.path;

      final lastIndex = filePath.lastIndexOf(RegExp(r'.'));
      final splitted = filePath.substring(0, (lastIndex));
      final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
      emit(AuthLoading());
      var compressedImage = await FlutterImageCompress.compressAndGetFile(
        file.path,
        outPath,
        quality: 30,
      );
      image = compressedImage;
      var res = await Repository().editUser(image);
    } else {
      emit(ImageError());
    }
  }

  void _checkUser(CheckUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    if (event.codeUser.length == 5) {
      if (event.codeUser == code.toString()) {
        var result =
            await Repository().checkIsUserExist(event.phone, event.code);
        if (result != null) {
          if (result.token != null) {
            await SharedPreferences.getInstance()
              ..setString('token', result.token!);
            token = result.token;
            sl<AuthConfig>().token = result.token;
          }
          secretKey = result.secretKey;
          emit(
            CodeSuccess(
              result.token != null ? ExistUser.exist : ExistUser.notExist,
              result.token != null ? result.token! : result.secretKey!,
            ),
          );
          return;
        } else {
          emit(CodeError('Ошибка code: $result'));
          return;
        }
      } else {
        if (code == null) {
          emit(CodeError('Срок кода истёк'));
          return;
        } else {
          emit(CodeError('Код введён неверно'));
          return;
        }
      }
    } else if (event.codeUser.isEmpty) {
      emit(CodeError('Введите код'));
    } else {
      emit(CodeError('Код введён неверно'));
    }
  }

  void _setNickname(SetNickname event, Emitter<AuthState> emit) {
    if (event.nickname.isNotEmpty) {
      if (event.nickname.length > 12) {
        emit(NicknameError('Максимальное количество символов 12'));
      } else {
        nickname = event.nickname;
        emit(NicknameSuccess(true));
      }
    } else {
      emit(NicknameError('Введите никнейм'));
    }
  }

  void _pickImage(PickImage event, Emitter<AuthState> emit) async {
    var result = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    //print(result);
    if (result != null) {
      var file = File(result.path);
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
      emit(ImageSuccess(result));
      image = compressedImage;
    } else {
      emit(ImageError());
    }
  }

  void _initUser(InitUser event, Emitter<AuthState> emit) async {
    try {
      var result = await Repository().initUser(secretKey ?? '', nickname ?? '',
          image == null ? null : File(image!.path));

      if (result != null) {
        token = result;
        await SharedPreferences.getInstance()
          ..setString('token', result);
        emit(InitSuccess(result));
      } else {
        emit(InitError('Выберите аватарку'));
      }
    } catch (e) {
      emit(InitError('Выберите аватарку'));
    }
  }

  void _getUser(GetUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    var result = await Repository().getUser();

    if (result != null) {
      sl<AuthConfig>().user = result;
      user = result;
      emit(GetUserSuccess(result));
    } else {
      emit(GetUserError());
    }
  }

  // void _searchUser(SearchUser event, Emitter<AuthState> emit) async {
  //   // emit(AuthLoading());
  //   var result = await Repository().getUser();

  //   if (result != null) {
  //     user = result;

  //     if (result.status == null) {
  //       emit(ReletionshipsError());
  //     } else if (result.status != 'Принято') {
  //       if (result.fromYou != null) {
  //         if (!result.fromYou!) {
  //           emit(ReceiveInvite());
  //         }
  //       } else {
  //         emit(GetUserSuccess(result));
  //       }
  //     } else {
  //       if (result.date == null) {
  //         emit(InviteAccepted(result.fromYou!));
  //       } else {
  //         MySecureStorage().setToken(token!);
  //         MySharedPrefs().setUser(token!, result);
  //         emit(ReletionshipsStarted());
  //       }
  //     }
  //     // print('huy');
  //   } else {
  //     emit(GetUserError());
  //   }
  // }

  void _inviteUser(InviteUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    if (event.phone.length == 12) {
      var result = await Repository().inviteUser(event.phone);
      //print(result);

      print('${result?.date} -дата');
      if (result?.date == null) {
        emit(InviteError400('Нет такого номера'));
      }
      if (result != null) {
        user = result;
        emit(InviteSuccess());
      } else {
        emit(InviteError('Укажите номер пользователя'));
      }
    } else {
      // print('objecterror');
      emit(InviteError('Укажите номер пользователя'));
      return;
    }
  }

  void _deleteInviteUser(
      DeleteInviteUser event, Emitter<AuthState> emit) async {

    if(user?.relationId == null) {
     var result = await Repository().getUser();

      if (result != null) {
        user = result;
      }
    }
    if (user?.relationId != null) {
      emit(AuthLoading());
      var result = await Repository().deleteInviteUser(user!.relationId!);

      if (result != null) {
        user = result;
        emit(DeleteInviteSuccess());
      } else {
        emit(DeleteInviteError());
      }
    }
  }

  void _startRelationShips(
      StartRelationships event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    var result =
        await Repository().startRelationships(event.date, user!.relationId!);

    if (result != null) {
      MySecureStorage().setToken(token!);
      sl<AuthConfig>().token = token;
      MySharedPrefs().setUser(token!, result);
      user = result;
      sl<AuthConfig>().user = user;
      emit(ReletionshipsStarted());
    } else {
      emit(ReletionshipsError());
    }
  }

  void _checkPhoneNumber(
      CheckIsUserPhone event, Emitter<AuthState> emit) async {
    // emit(AuthLoading());
    var result = await Repository().checkPhoneNumber(event.phone);

    if (result != null && result) {
      emit(CheckIsUserExistSuccess());
    } else {
      emit(CheckIsUserExistError());
    }
  }

  void _acceptInviteUser(
      AcceptReletionships event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    var result = await Repository().acceptRelationships(user!.relationId!);

    if (result != null) {
      user = result;
      emit(ReletionshipsAccepted());
    } else {
      emit(ReletionshipsAcceptedError());
    }
  }

  void _logOut(LogOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await Repository().deleteInviteUser(
        ((await MySharedPrefs().user) as UserAnswer).relationId!);
    // ignore: use_build_context_synchronously
    MySharedPrefs().logOut(event.context);
    emit(AuthStated());
  }

  void _textFieldChangeState(
      TextFieldFilled event, Emitter<AuthState> emit) async {
    if (event.filled) {
      emit(TextFieldSuccess());
    } else {
      emit(TextFieldError());
    }
  }
}
