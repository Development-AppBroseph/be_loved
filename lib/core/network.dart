import 'package:be_loved/models/profile.dart';
import 'package:dio/dio.dart';
import 'constants.dart';

class NetHandler {
  static var uri = Uri.parse(apiUrl);
  var dio = Dio();

  Future<Profile?> getProfile() async {
    try {
      var response = await dio.get(
        'http://195.133.49.15:8000/auth/users',
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
}
