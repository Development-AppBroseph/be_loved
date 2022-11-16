import 'dart:convert';
import 'dart:io';
import 'package:be_loved/core/utils/helpers/dio_helper.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/database/auth_params.dart';
import '../../../../../core/services/network/endpoints.dart';
import '../../../../../locator.dart';

abstract class ProfileRemoteDataSource {
  Future<User> editProfile(User user, File? file);

}

class ProfileRemoteDataSourceImpl
    implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});
  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json"
  };

  @override
  Future<User> editProfile(User user, File? file) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Map map = user.toJson();
    map['avatar'] = file == null ? null : await MultipartFile.fromFile(file.path);
    Response response = await dio.put(Endpoints.editProfile.getPath(),
        data: jsonEncode(map),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 499,
            headers: headers));
    printRes(response);
    if (response.statusCode == 200) {
      return User.fromJson(response.data);
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }
}
