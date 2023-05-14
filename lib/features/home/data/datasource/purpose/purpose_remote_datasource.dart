import 'package:be_loved/core/utils/helpers/dio_helper.dart';
import 'package:be_loved/features/home/data/models/purposes/actual_model.dart';
import 'package:be_loved/features/home/data/models/purposes/full_purpose_model.dart';
import 'package:be_loved/features/home/data/models/purposes/promos_model.dart';
import 'package:be_loved/features/home/data/models/purposes/purpose_model.dart';
import 'package:be_loved/features/home/domain/entities/purposes/actual_entiti.dart';
import 'package:be_loved/features/home/domain/entities/purposes/full_purpose_entity.dart';
import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/database/auth_params.dart';
import '../../../../../core/services/network/endpoints.dart';
import '../../../../../locator.dart';
import '../../../domain/entities/purposes/promos_entiti.dart';

abstract class PurposeRemoteDataSource {
  Future<PurposeEntity> getSeasonPurpose();
  Future<List<PurposeEntity>> getAvailablePurposes(double lat, double long);
  Future<List<FullPurposeEntity>> getInProcessPurposes();
  Future<List<FullPurposeEntity>> getHistoryPurposes();
  Future<void> completePurpose(int target);
  Future<void> cancelPurpose(int target);
  Future<void> sendPhotoPurpose(String path, int target);
  Future<List<PromosEntiti>> getPromos();
  Future<List<ActualEntiti>> getActual();
}

class PurposeRemoteDataSourceImpl implements PurposeRemoteDataSource {
  final Dio dio;

  PurposeRemoteDataSourceImpl({required this.dio}) {
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

  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json"
  };

  //Get season main purpose
  @override
  Future<PurposeEntity> getSeasonPurpose() async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.get(Endpoints.getSeasonPurpose.getPath(),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    print('DATA SEAS: ${response.data}');
    if (response.statusCode == 200) {
      return PurposeModel.fromJson(response.data);
    } else if (response.statusCode == 401) {
      throw ServerException(message: 'token_error');
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  @override
  Future<List<PurposeEntity>> getAvailablePurposes(
      double lat, double long) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.get(
      Endpoints.getAvailablePurposes.getPath(),
      queryParameters: {'lat': 63.2773775988409, 'lon': 90.82074510026895},
      options: Options(
        followRedirects: false,
        validateStatus: (status) => status! < 599,
        headers: headers,
      ),
    );
    printRes(response);
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => PurposeModel.fromJson(json))
          .toList();
    } else if (response.statusCode == 401) {
      throw ServerException(message: 'token_error');
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  @override
  Future<List<FullPurposeEntity>> getInProcessPurposes() async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    // headers["Authorization"] = "Token d232dfc78ec938eacc832b0b23aa20c63eaab7ae7c544a63658cb0e2cbed2c7d";
    Response response = await dio.get(Endpoints.getInProcessPurposes.getPath(),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => FullPurposeModel.fromJson(json))
          .toList();
    } else if (response.statusCode == 401) {
      throw ServerException(message: 'token_error');
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  //Complete purpose
  @override
  Future<void> completePurpose(int target) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.post(Endpoints.sendPurpose.getPath(),
        data: FormData.fromMap({'target': target}),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    print(response.statusCode);
    if (response.statusCode == 201) {
      return;
    } else if (response.statusCode == 401) {
      throw ServerException(message: 'token_error');
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  //History purposes
  @override
  Future<List<FullPurposeEntity>> getHistoryPurposes() async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    // headers["Authorization"] = "Token d232dfc78ec938eacc832b0b23aa20c63eaab7ae7c544a63658cb0e2cbed2c7d";
    Response response = await dio.get(Endpoints.getHistoryPurposes.getPath(),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => FullPurposeModel.fromJson(json))
          .toList();
    } else if (response.statusCode == 401) {
      throw ServerException(message: 'token_error');
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  //Send photo purpose
  @override
  Future<void> sendPhotoPurpose(String path, int target) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    // headers["Authorization"] = "Token d232dfc78ec938eacc832b0b23aa20c63eaab7ae7c544a63658cb0e2cbed2c7d";
    Response response = await dio.patch(
        Endpoints.sendPhotoPurpose.getPath(params: [target]),
        data: FormData.fromMap({'photo': await MultipartFile.fromFile(path)}),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      throw ServerException(message: 'token_error');
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  //Cancel purpose
  @override
  Future<void> cancelPurpose(int target) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.delete(
        Endpoints.sendPhotoPurpose.getPath(params: [target]),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    if (!(response.statusCode! < 200 || response.statusCode! > 204)) {
      return;
    } else if (response.statusCode == 401) {
      throw ServerException(message: 'token_error');
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  @override
  Future<List<PromosEntiti>> getPromos() async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.get(
      Endpoints.getPromos.getPath(),
      options: Options(
        headers: headers,
        followRedirects: false,
        validateStatus: (status) => status! < 599,
      ),
    );
    printRes(response);
    if (response.statusCode! <= 200 || response.statusCode! > 204) {
      return (response.data as List<dynamic>)
          .map((json) => PromosModel.fromJson(json))
          .toList();
    } else if (response.statusCode == 401) {
      throw ServerException(message: 'token_error');
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }

  @override
  Future<List<ActualEntiti>> getActual() async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.get(
      Endpoints.getActual.getPath(),
      options: Options(
        headers: headers,
        followRedirects: false,
        validateStatus: (status) => status! < 599,
      ),
    );
    if (response.statusCode! <= 200 || response.statusCode! > 204) {
      return (response.data as List<dynamic>)
          .map((json) => ActualModel.fromJson(json))
          .toList();
    } else if (response.statusCode == 401) {
      throw ServerException(message: 'token_error');
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }
}
