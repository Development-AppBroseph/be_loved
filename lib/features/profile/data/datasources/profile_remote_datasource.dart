import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:be_loved/core/utils/helpers/dio_helper.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/home/data/models/statics/statics_model.dart';
import 'package:be_loved/features/home/domain/entities/statics/statics_entity.dart';
import 'package:be_loved/features/profile/data/models/back_model.dart';
import 'package:be_loved/features/profile/data/models/subscription_model.dart';
import 'package:be_loved/features/profile/domain/entities/back_entity.dart';
import 'package:be_loved/features/profile/domain/entities/subscription_entiti.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/database/auth_params.dart';
import '../../../../../core/services/network/endpoints.dart';
import '../../../../../locator.dart';

abstract class ProfileRemoteDataSource {
  Future<User> editProfile(User user, File? file);
  Future<String> editRelation(int id, String relationName, String date);

  Future<StaticsEntity> getStats();

  Future<String> connectVK(String code);

  Future<void> sendFilesToMail(String email, bool isParting);

  Future<BackEntity> getBackgroundInfo();
  Future<void> editBackgroundInfo(BackEntity back, File? file);
  Future<SubEntiti> getStatusSub();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
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
    map['photo'] =
        file == null ? null : await MultipartFile.fromFile(file.path);
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
  Future<String> editRelation(int id, String relationName, String date) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.put(Endpoints.editRelations.getPath(),
        data: FormData.fromMap({
          'relation_id': id,
          'name': relationName,
          'date': date.substring(0, 10)
        }),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    print('dATA: ${date}');
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

  //VK
  @override
  Future<String> connectVK(String code) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.post(Endpoints.vkAuth.getPath(),
        data: FormData.fromMap({'code': code}),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    print('dATA: ${response.data}');
    //Уже акк есть и сразу вход
    if (response.statusCode == 200 && response.data['token'] != null) {
      return response.data['token'];
    }
    if (response.statusCode == 403) {
      return response.data;
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  //Send files to email
  @override
  Future<void> sendFilesToMail(String email, bool isParting) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    if (isParting) {
      Response response = await dio.put(Endpoints.editRelations.getPath(),
          data: FormData.fromMap({
            if (email != '') 'email': email,
            'relation_id': sl<AuthConfig>().user!.relationId,
            'status': 'Отменено'
          }),
          options: Options(
              followRedirects: false,
              validateStatus: (status) => status! < 599,
              headers: headers));
      printRes(response);
      print('EMAIL FILES: ${response.data}');
      if (!(response.statusCode! < 200 || response.statusCode! > 204)) {
        return;
      } else {
        throw ServerException(message: 'Ошибка с сервером');
      }
    }

    Response response = await dio.post(Endpoints.sendFilesToMail.getPath(),
        data: FormData.fromMap({
          'email': email,
        }),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    print('EMAIL FILES: ${response.data}');
    if (!(response.statusCode! < 200 || response.statusCode! > 204)) {
      return;
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  @override
  Future<BackEntity> getBackgroundInfo() async {
    print(sl<AuthConfig>().token);
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.get(Endpoints.getBacks.getPath(),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    print('RES ${response.statusCode}: ${response.data}');
    if (response.statusCode == 200) {
      if (response.data['relation'] == null) {
        Response response2 = await dio.post(Endpoints.setBacks.getPath(),
            options: Options(
                followRedirects: false,
                validateStatus: (status) => status! < 599,
                headers: headers));
        printRes(response2);
      }
      return BackModel.fromJson(response.data);
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  @override
  Future<void> editBackgroundInfo(BackEntity back, File? file) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.put(Endpoints.setBacks.getPath(),
        data: jsonEncode({
          'asset_photo': back.assetPhoto,
          "main_photo": back.backPhoto,
          if (file != null) 'photos': [await MultipartFile.fromFile(file.path)]
        }),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    print('RES: ${response.data}');
    print('RES STATUS CODE: ${response.statusCode}');
    if (response.statusCode == 201) {
      return;
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  @override
  Future<SubEntiti> getStatusSub() async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.get(
      Endpoints.statusSub.getPath(),
      options: Options(
        followRedirects: false,
        validateStatus: (status) => status! < 599,
        headers: headers,
      ),
    );
    print('ResStatusCode: ${response.statusCode}\tResData: ${response.data}');
    if (response.statusCode == 200) {
      return SubModel.fromJson(response.data);
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }
}
