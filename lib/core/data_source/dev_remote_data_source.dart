import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:be_loved/core/domain/interface/general_ressponse_body.dart';
import 'package:be_loved/core/domain/object/general_callback_result.dart';
import 'package:data_source/callback_result/callback_result.dart';
import 'package:data_source/data_source/data_source.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

base class DevRemoteDataSource
    extends RemoteDataSource<GeneralResponseBody, Map<String, dynamic>> {
  @override
  final String baseUrl = 'https://beloved-app.ru/';

  final _logger = Logger(
    printer: PrefixPrinter(
      PrettyPrinter(
        methodCount: 0,
        printTime: true,
        colors: Platform.isIOS ? false : true,
      ),
    ),
  );

  @override
  HeadersType headers = {
    'Content-Type': 'application/json',
    'accept': 'application/json',
  };

  @override
  OnErrorDioInterceptor onError = (error, handler) {
    return handler.next(error);
  };

  @override
  late OnRequestDioInterceptor onRequest = (request, handler) {
    final requestData = request.data;
    // final authService = AuthService.instance;
    // if (authService.isLoggedIn) {
    //   final initialHeader = {
    //     'Authorization': 'Bearer ${authService.authCreds()?.token}',
    //     'role': '${authService.authCreds()?.role}',
    //     'subdomain': '${authService.authCreds()?.subdomain}'
    //   };
    //   request.headers.addAll(initialHeader);
    // }

    List<String> filesNames = [];
    String? bodyString;
    if (requestData is FormData) {
      filesNames = requestData.files
          .map((f) => f.value.filename)
          .whereType<String>()
          .toList();
      final filesNamesString =
          filesNames.isEmpty ? '' : ' (${filesNames.join(', ')})';
      bodyString =
          'FormData fields: ${request.data.fields}, files: ${request.data.files?.length}$filesNamesString';
    } else if (requestData is String && requestData.isNotEmpty) {
      bodyString = jsonEncode(requestData);
    }

    _logger.i([
      '🌎 ${request.method} ${request.uri}',
      'HEADERS:',
      request.headers,
      if (request.queryParameters.isNotEmpty) ...[
        'QUERY PARAMETERS:',
        request.queryParameters,
      ],
      'BODY:',
      bodyString ?? requestData,
    ]);

    return handler.next(request);
  };

  @override
  late OnResponseDioInterceptor onResponse = (response, handler) {
    _logger.w([
      'status code: ${response.statusCode}',
      '🌎 ${response.requestOptions.method} ${response.realUri}',
      response.data,
    ]);

    return handler.next(response);
  };

  @override
  Future<RemoteCbResult<T?>> request<T>(
      ClientCallback<GeneralResponseBody> callback) async {
    try {
      final callbackResult = await callback.call();
      final statusCode = callbackResult.response.statusCode;
      if (statusCode == null) {
        return const RemoteCbResult(callbackStatus: CallbackStatus.fail);
      }
      if (statusCode >= 200 && statusCode < 300) {
        return RemoteCbResult(
          callbackStatus: CallbackStatus.success,
          data: callbackResult.data.data,
          errors: callbackResult.data.errors,
          message: callbackResult.data.message,
        );
      } else if (statusCode >= 400 && statusCode < 500) {
        return RemoteCbResult(
          callbackStatus: CallbackStatus.fail,
          statusCode: statusCode,
          data: callbackResult.data.data,
          errors: callbackResult.data.errors,
          message: callbackResult.data.message,
        );
      } else {
        return RemoteCbResult(
          callbackStatus: CallbackStatus.fail,
          errors: callbackResult.data.errors,
          message: callbackResult.data.message,
        );
      }
    } catch (ex, stackTrace) {
      log('request', error: ex, stackTrace: stackTrace);
      return const RemoteCbResult(
        callbackStatus: CallbackStatus.fail,
      );
    }
  }
}
