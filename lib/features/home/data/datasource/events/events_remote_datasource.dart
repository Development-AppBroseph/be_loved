import 'dart:convert';
import 'package:be_loved/core/utils/helpers/dio_helper.dart';
import 'package:be_loved/features/home/data/models/events/event_model.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/database/auth_params.dart';
import '../../../../../core/services/network/endpoints.dart';
import '../../../../../locator.dart';

abstract class EventsRemoteDataSource {
  Future<List<EventEntity>> getEvents();
  Future<bool> addEvent(EventEntity eventEntity);

}

class EventsRemoteDataSourceImpl
    implements EventsRemoteDataSource {
  final Dio dio;

  EventsRemoteDataSourceImpl({required this.dio});
  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json"
  };


  //Get test
  @override
  Future<List<EventEntity>> getEvents() async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.get(Endpoints.getEvents.getPath(),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 499,
            headers: headers));
    printRes(response);
    if (response.statusCode == 200) {
      return (response.data as List)
            .map((json) => EventModel.fromJson(json))
            .toList();
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }



  @override
  Future<bool> addEvent(EventEntity eventEntity) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.post(Endpoints.addEvent.getPath(),
        data: jsonEncode(eventEntity.toMap()),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 499,
            headers: headers));
    printRes(response);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }
}
