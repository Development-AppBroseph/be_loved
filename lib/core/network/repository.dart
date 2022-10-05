import 'dart:io';

import 'package:be_loved/core/helpers/shared_prefs.dart';
import 'package:be_loved/models/auth/check_is_user_exist.dart';
import 'package:be_loved/models/auth/check_nickName.dart';
import 'package:be_loved/models/helpers/details.dart';
import 'package:be_loved/models/auth/init_user.dart';
import 'package:be_loved/models/user/user.dart';
import 'package:be_loved/widgets/alerts/snack_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../helpers/constants.dart';

class Repository {
  static var uri = Uri.parse(apiUrl);
  var dio = Dio(
    BaseOptions(baseUrl: apiUrl, validateStatus: (status) => status! <= 400),
  );

  // Future<Profile?> getProfile() async {
  //   try {
  //     var response = await dio.get('$apiUrl/users');

  //     if (response.statusCode == 400) {
  //       StandartSnackBar.show(
  //         DetailsAnswer.fromJson(response.data).details,
  //         SnackBarStatus(Icons.error, redColor),
  //       );
  //     }
  //     if (response.statusCode == 200) {
  //       return Profile.fromJson(response.data);
  //     }
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  Future<bool?> editUser(File? file) async {
    var options = Options(headers: {
      'Authorization': 'Token ${await MySharedPrefs().token}',
    }, validateStatus: (status) => status! <= 500);

    try {
      var response = await dio.put('auth/users',
          options: options,
          data: FormData.fromMap({
            'photo': MultipartFile.fromFileSync(file!.path, filename: file.path)
          }));
      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode == 400) {
        StandartSnackBar.show(
          DetailsAnswer.fromJson(
            response.data,
            response.data.toString().split(':').first.substring(
                  1,
                  response.data.toString().split(':').length,
                ),
          ).details,
          SnackBarStatus(Icons.error, redColor),
        );
      }
      return false;
    } catch (e) {
      StandartSnackBar.show(
        'Ошибка сервера. Мы это уже исправляем.',
        SnackBarStatus(Icons.error, redColor),
      );
      return false;
    }
  }

  Future<int?> registration(String number) async {
    try {
      var response =
          await dio.post('auth/code_phone', data: {'phone_number': number});
      if (response.statusCode == 204) {
        return 12345;
      }
      if (response.statusCode == 400) {
        StandartSnackBar.show(
          DetailsAnswer.fromJson(
            response.data,
            response.data.toString().split(':').first.substring(
                  1,
                  response.data.toString().split(':').length,
                ),
          ).details,
          SnackBarStatus(Icons.error, redColor),
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<CheckIsUserExist?> checkIsUserExist(String number, int code) async {
    try {
      var response = await dio.put('auth/code_phone', data: {
        'phone_number': number,
        'code': code,
      });
      if (response.statusCode == 200) {
        return CheckIsUserExist.fromJson(response.data);
      }
      if (response.statusCode == 400) {
        // StandartSnackBar.show(
        //   DetailsAnswer.fromJson(response.data).details,
        //   SnackBarStatus(Icons.error, redColor),
        // );
      }
      return null;
    } catch (e) {
      // StandartSnackBar.show(
      //   'Ошибка сервера. Мы это уже исправляем.',
      //   SnackBarStatus(Icons.error, redColor),
      // );
      return null;
    }
  }

  Future<bool?> checkNickName(String name) async {
    try {
      var response = await dio.get(
        'auth/code_phone',
        queryParameters: {
          'username': name,
        },
      );
      if (response.statusCode == 200) {
        return CheckNickName.fromJson(response.data).exists;
      }
      if (response.statusCode == 400) {
        StandartSnackBar.show(
          DetailsAnswer.fromJson(
            response.data,
            response.data.toString().split(':').first.substring(
                  1,
                  response.data.toString().split(':').length,
                ),
          ).details,
          SnackBarStatus(Icons.error, redColor),
        );
      }
      return null;
    } catch (e) {
      StandartSnackBar.show(
        'Ошибка сервера. Мы это уже исправляем.',
        SnackBarStatus(Icons.error, redColor),
      );
      return null;
    }
  }

  Future<String?> initUser(
      String secretKey, String nickname, File? xFile) async {
    try {
      var response = await dio.post(
        'auth/users',
        data: FormData.fromMap(
          {
            'secret_key': secretKey,
            'username': nickname,
            'photo': xFile != null
                ? MultipartFile.fromFileSync(xFile.path, filename: xFile.path)
                : null,
          },
        ),
        options: Options(
          validateStatus: (status) => status! <= 450,
        ),
      );

      if (response.statusCode == 200) {
        return InitUserAnswer.fromJson(response.data).authToken;
      }
      if (response.statusCode == 400) {
        StandartSnackBar.show(
          DetailsAnswer.fromJson(
            response.data,
            response.data.toString().split(':').first.substring(
                  1,
                  response.data.toString().split(':').length,
                ),
          ).details,
          SnackBarStatus(Icons.error, redColor),
        );
      }
      return null;
    } catch (e) {
      StandartSnackBar.show(
        'Ошибка сервера. Мы это уже исправляем.',
        SnackBarStatus(Icons.error, redColor),
      );
      return null;
    }
  }

  Future<UserAnswer?> inviteUser(String phone) async {
    var options = Options(headers: {
      'Authorization': 'Token ${await MySharedPrefs().token}',
    }, validateStatus: (status) => status! <= 400);
    print('phone');
    try {
      var response = await dio.post(
        '/relations/',
        data: {
          "to_phone_number": phone,
        },
        options: options,
      );
      if (response.statusCode == 200) {
        return UserAnswer.fromJson(response.data);
      }
      if (response.statusCode == 400) {
        StandartSnackBar.show(
          DetailsAnswer.fromJson(
            response.data,
            response.data.toString().split(':').first.substring(
                  1,
                  response.data.toString().split(':').first.length,
                ),
          ).details,
          SnackBarStatus(Icons.error, redColor),
        );
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<UserAnswer?> deleteInviteUser(int relationId) async {
    var options = Options(headers: {
      'Authorization': 'Token ${await MySharedPrefs().token}',
    }, validateStatus: (status) => status! <= 500);

    try {
      var response = await dio.put(
        '/relations/',
        data: {"relation_id": relationId, "status": 'Отменено'},
        options: options,
      );
      if (response.statusCode == 200) {
        return UserAnswer.fromJson(response.data);
      }
      if (response.statusCode == 400) {
        StandartSnackBar.show(
          DetailsAnswer.fromJson(
            response.data,
            response.data.toString().split(':').first.substring(
                  1,
                  response.data.toString().split(':').length,
                ),
          ).details,
          SnackBarStatus(Icons.error, redColor),
        );
      }
      if (response.statusCode == 400) {
        StandartSnackBar.show(
          'Невозможно отправить приглашение',
          SnackBarStatus(Icons.error, redColor),
        );
      }

      return null;
    } catch (e) {
      StandartSnackBar.show(
        'Ошибка сервера. Мы это уже исправляем.',
        SnackBarStatus(Icons.error, redColor),
      );
      return null;
    }
  }

  Future<UserAnswer?> getUser() async {
    var options = Options(headers: {
      'Authorization': 'Token ${await MySharedPrefs().token}',
    });
    try {
      var response = await dio.get(
        'auth/users',
        options: options,
      );

      if (response.statusCode == 200) {
        return UserAnswer.fromJson(response.data);
      }
      if (response.statusCode == 400) {
        StandartSnackBar.show(
          DetailsAnswer.fromJson(
            response.data,
            response.data.toString().split(':').first.substring(
                  1,
                  response.data.toString().split(':').length,
                ),
          ).details,
          SnackBarStatus(Icons.error, redColor),
        );
      }
      return null;
    } catch (e) {
      StandartSnackBar.show(
        'Ошибка сервера. Мы это уже исправляем.',
        SnackBarStatus(Icons.error, redColor),
      );
      return null;
    }
  }

  Future<UserAnswer?> startRelationships(String date, int relationId) async {
    var options = Options(headers: {
      'Authorization': 'Token ${await MySharedPrefs().token}',
    }, validateStatus: (status) => status! <= 500);
    try {
      var response = await dio.put(
        '/relations/',
        data: {"date": date, "relation_id": relationId},
        options: options,
      );

      if (response.statusCode == 200) {
        return UserAnswer.fromJson(response.data);
      }
      if (response.statusCode == 400) {
        StandartSnackBar.show(
          DetailsAnswer.fromJson(
            response.data,
            response.data.toString().split(':').first.substring(
                  1,
                  response.data.toString().split(':').length,
                ),
          ).details,
          SnackBarStatus(Icons.error, redColor),
        );
      }

      return null;
    } catch (e) {
      StandartSnackBar.show(
        'Ошибка сервера. Мы это уже исправляем.',
        SnackBarStatus(Icons.error, redColor),
      );
      return null;
    }
  }

  Future<UserAnswer?> acceptRelationships(int relationId) async {
    var options = Options(headers: {
      'Authorization': 'Token ${await MySharedPrefs().token}',
    }, validateStatus: (status) => status! <= 500);
    try {
      var response = await dio.put(
        '/relations/',
        data: {"relation_id": relationId, "status": 'Принято'},
        options: options,
      );

      if (response.statusCode == 200) {
        return UserAnswer.fromJson(response.data);
      }
      if (response.statusCode == 400) {
        StandartSnackBar.show(
          DetailsAnswer.fromJson(
            response.data,
            response.data.toString().split(':').first.substring(
                  1,
                  response.data.toString().split(':').length,
                ),
          ).details,
          SnackBarStatus(Icons.error, redColor),
        );
      }
      if (response.statusCode == 400) {
        StandartSnackBar.show(
          'Невозможно отправить приглашение',
          SnackBarStatus(Icons.error, redColor),
        );
      }

      return null;
    } catch (e) {
      StandartSnackBar.show(
        'Ошибка сервера. Мы это уже исправляем.',
        SnackBarStatus(Icons.error, redColor),
      );
      return null;
    }
  }
}
