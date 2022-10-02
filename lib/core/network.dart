import 'package:be_loved/models/profile.dart';
import 'package:dio/dio.dart';
import '../models/user_name.dart';
import 'constants.dart';

class NetHandler {
  static var uri = Uri.parse(apiUrl);
  var dio = Dio();

  Future<Profile?> getProfile() async {
    try {
      var response = await dio.get(
        '$apiUrl/users',
        options: Options(
            headers: {"Authorization": token}
        )
      );

      return Profile.fromJson(response.data);
    }
    catch (e) {
      print(e);
      return null;
    }
  }

  Future<int?> registration(String number) async {
    try {
      var response = await dio.post(
          '$apiUrl/code_phone',
          data: {
            'phone_number': number
          }
      );
      if (response.statusCode == 204) {
        return 12345;
      }

      return null;
    }
    catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool?> checkNickName(String name) async {
    try {
      var response = await dio.get(
          '$apiUrl/users',
          options: Options(
            headers: {
              'user_name': name
            }
          )
      );
      if (response.statusCode == 200) {
        print(response.isRedirect);
        return response.isRedirect;
      }

      return null;
    }
    catch (e) {
      print(e);
      return null;
    }
  }
}
