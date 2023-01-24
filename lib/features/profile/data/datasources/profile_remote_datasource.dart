import 'dart:convert';
import 'dart:io';
import 'package:be_loved/core/utils/helpers/dio_helper.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/home/data/models/statics/statics_model.dart';
import 'package:be_loved/features/home/domain/entities/statics/statics_entity.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/database/auth_params.dart';
import '../../../../../core/services/network/endpoints.dart';
import '../../../../../locator.dart';

abstract class ProfileRemoteDataSource {
  Future<User> editProfile(User user, File? file);
  Future<String> editRelation(int id, String relationName, String theme);

  Future<StaticsEntity> getStats();

}

class ProfileRemoteDataSourceImpl
    implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});
  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  @override
  Future<User> editProfile(User user, File? file) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    headers["Content-Type"] = "multipart/form-data";
    Map<String, dynamic> map = user.toJson();
    map['photo'] = file == null ? null : await MultipartFile.fromFile(file.path);
    Response response = await dio.put(Endpoints.editProfile.getPath(),
        data: FormData.fromMap(map),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    print('RES: ${response.statusCode}');
    print('RES: ${response.data}');
    if (response.statusCode == 200) {
      return User.fromJson(response.data['me']);
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }






  @override
  Future<String> editRelation(int id, String relationName, String theme) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.put(Endpoints.editRelations.getPath(),
        data: FormData.fromMap({
          'relation_id': id,
          'name': relationName,
          'theme': theme
        }),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    if (response.statusCode == 200) {
      return relationName;
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }




  @override
  Future<StaticsEntity> getStats() async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.get(Endpoints.getStats.getPath(),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    print('RES: ${response.data}');
    if (response.statusCode == 200) {
      return StaticsModel.fromJson(response.data);
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }
}
