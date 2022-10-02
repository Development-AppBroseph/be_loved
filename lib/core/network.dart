import 'package:be_loved/models/check_nickName.dart';
import 'package:be_loved/models/profile.dart';
import 'package:dio/dio.dart';
import 'constants.dart';

class NetHandler {
  static var uri = Uri.parse(apiUrl);
  var dio = Dio(BaseOptions(
    baseUrl: apiUrl,
  ));

  Future<Profile?> getProfile() async {
    try {
      var response = await dio.get('$apiUrl/users',
          options: Options(headers: {"Authorization": token}));

      return Profile.fromJson(response.data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<int?> registration(String number) async {
    print(number);
    try {
      var response =
          await dio.post('auth/code_phone', data: {'phone_number': number});
      if (response.statusCode == 204) {
        return 12345;
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> checkIsUserExist(String number, String code) async {
    print(number);
    try {
      var response =
      await dio.put(
          'auth/code_phone',
          options: Options(
              headers: {
                'phone_number': number,
                'code': code,
              }
          )
          );
      if (response.statusCode == 200) {
        return response.data;
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool?> checkNickName(String name) async {
    try {
      var response = await dio.get('auth/code_phone',
          options: Options(
              headers: {
                'username': name,
              }
          ));
      if (response.statusCode == 200) {
        return CheckNickName.fromJson(response.data).exists;
      }

      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
