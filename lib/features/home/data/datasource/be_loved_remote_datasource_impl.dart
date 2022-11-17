import 'dart:convert';

import 'package:be_loved/core/error/exceptions.dart';
import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/core/services/network/endpoints.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'be_loved_remote_datasource.dart';

class BeLovedRemoteDatasourceImpl implements BeLovedRemoteDatasource {
  final Dio dio;

  BeLovedRemoteDatasourceImpl({required this.dio}) {
    initializeInterceptor();
  }
  initializeInterceptor() {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  @override
  Future<void> postNumber({
    required String phoneNumber,
  }) async {
    final userToken = await MySharedPrefs().token;
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Token $userToken',
    };
    final userNumber = FormData.fromMap({
      "phone_number": phoneNumber,
    });
    final response = await dio.post(
      Endpoints.phoneNumber.getPath(),
      data: userNumber,
      options: Options(
        followRedirects: false,
        validateStatus: (status) => status! < 499,
        headers: headers,
      ),
    );

    print('RES: ${response.statusCode} ||| ${response.data}');
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      print(true);
    } else if (response.statusCode == 400) {
      if(response.data['phone_number'] != null && response.data['phone_number'] == 'Телефон занят'){
        throw ServerException(message: 'Телефон занят');
      }
      throw ServerException(message: 'Попробуйте через 1 минуту');
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  @override
  Future<void> putCode({required int code}) async {
    final userToken = await MySharedPrefs().token;
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Token $userToken',
    };
    print('CODE: ${code}');
    final userCode = jsonEncode({
      "code": code,
    });
    final response = await dio.put(
      Endpoints.phoneNumber.getPath(),
      data: userCode,
      options: Options(
        followRedirects: false,
        validateStatus: (status) => status! < 499,
        headers: headers,
      ),
    );
    print('RES: ${response.statusCode} ||| ${response.data}');
    if (response.statusCode! >= 200 && response.statusCode! < 400) {
      print(true);
    } else if (response.statusCode == 400) {
      throw ServerException(message: 'Неверный код');
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }
}
