import 'package:dio/dio.dart';

printRes(Response response){
  if(response.statusCode != 200 && response.statusCode != 201){
    print('res status: ${response.statusCode} --');
    print('res data: ${response.data} --');
  }
}