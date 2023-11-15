import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/core/utils/helpers/dio_helper.dart';
import 'package:be_loved/features/home/data/models/archive/gallery_file_model.dart';
import 'package:be_loved/features/home/data/models/home/levels_model.dart';
import 'package:be_loved/features/home/data/models/purposes/purpose_model.dart';
import 'package:be_loved/features/home/domain/entities/main_widgets/main_widgets_entity.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/network/endpoints.dart';

abstract class MainWidgetsRemoteDataSource {
  Future<MainWidgetsEntity> getMainWidgets();
  Future<void> addFileWidget(int id);
  Future<void> addPurposeWidget(int id);
  Future<void> deleteFileWidget(int id);
  Future<void> deletePurposeWidget(int id);
  Future<void> sendNotification();
  Future<List<LevelModel>> getLevels();
}

class MainWidgetsRemoteDataSourceImpl implements MainWidgetsRemoteDataSource {
  final Dio dio;

  MainWidgetsRemoteDataSourceImpl({required this.dio});
  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json"
  };

  @override
  Future<MainWidgetsEntity> getMainWidgets() async {
    headers["Authorization"] = "Token ${await MySharedPrefs().token}";
    Response response = await dio.get(Endpoints.getMainWidgets.getPath(),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 499,
            headers: headers));
    printRes(response);
    if (response.statusCode == 200) {
      final file = response.data['file'] == null
          ? null
          : GalleryFileModel.fromJson(response.data['file']);
      final purposes = response.data['targets'] == null
          ? null
          : (response.data['targets'] as List)
              .map((json) => PurposeModel.fromJson(json))
              .toList();

      return MainWidgetsEntity(file: file, purposes: purposes ?? []);
    } else if (response.statusCode == 401) {
      throw ServerException(message: 'token_error');
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  @override
  Future<void> addFileWidget(int id) async {
    headers["Authorization"] = "Token ${await MySharedPrefs().token}";
    Response response = await dio.post(
        Endpoints.addFileWidget.getPath(params: [id]),
        data: FormData.fromMap({'file': id}),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 699,
            headers: headers));
    printRes(response);
    if (!(response.statusCode! < 200 || response.statusCode! > 204)) {
      return;
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  @override
  Future<void> addPurposeWidget(int id) async {
    headers["Authorization"] = "Token ${await MySharedPrefs().token}";
    Response response = await dio.post(
        Endpoints.addPurposeWidget.getPath(params: [id]),
        data: FormData.fromMap({'target': id}),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 699,
            headers: headers));
    printRes(response);
    if (!(response.statusCode! < 200 || response.statusCode! > 204)) {
      return;
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  @override
  Future<void> deleteFileWidget(int id) async {
    headers["Authorization"] = "Token ${await MySharedPrefs().token}";
    Response response = await dio.delete(
        Endpoints.deleteFileWidget.getPath(params: [id]),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 699,
            headers: headers));
    printRes(response);
    if (!(response.statusCode! < 200 || response.statusCode! > 204)) {
      return;
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  @override
  Future<void> deletePurposeWidget(int id) async {
    headers["Authorization"] = "Token ${await MySharedPrefs().token}";
    Response response = await dio.delete(
        Endpoints.deletePurposeWidget.getPath(params: [id]),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 699,
            headers: headers));
    printRes(response);
    if (!(response.statusCode! < 200 || response.statusCode! > 204)) {
      return;
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  @override
  Future<void> sendNotification() async {
    final token = await FirebaseMessaging.instance.getToken();
    headers["Authorization"] = "Token ${await MySharedPrefs().token}";
    Response response = await dio.post(
      Endpoints.sendNoti.getPath(),
      data: {"fcm_token": token},
      options: Options(
        headers: headers,
      ),
    );
    print(token);
    print(response.statusCode);
    if (response.statusCode! >= 200 || response.statusCode! > 204) {
      return;
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  @override
  Future<List<LevelModel>> getLevels() async {
    headers["Authorization"] = "Token ${await MySharedPrefs().token}";
    Response response = await dio.get(
      Endpoints.levels.getPath(),
      options: Options(
        headers: headers,
      ),
    );
    if (response.statusCode! >= 200) {
      return List.from((response.data as List<dynamic>)
          .map((e) => LevelModel.fromJson(e))
          .toList());
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }
}
