import 'package:dio/dio.dart';

printRes(Response response){
  if(response.statusCode! < 200 || response.statusCode! > 204){
    print('res status: ${response.statusCode} --');
    print('res data: ${response.data} --');
    print('res method: ${response.requestOptions.method} --');
    print('res URI: ${response.requestOptions.uri} --');
  }
}