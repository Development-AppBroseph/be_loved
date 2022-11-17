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
  Future<EventEntity> addEvent(EventEntity eventEntity);
  Future<EventEntity> editEvent(EventEntity eventEntity);
  Future<void> deleteEvent(List<int> ids);

}

class EventsRemoteDataSourceImpl
    implements EventsRemoteDataSource {
  final Dio dio;

  EventsRemoteDataSourceImpl({required this.dio});
  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json"
  };


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
    } else if(response.statusCode == 401){
      throw ServerException(message: 'token_error');
    }else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }



  @override
  Future<EventEntity> addEvent(EventEntity eventEntity) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.post(Endpoints.addEvent.getPath(),
        data: jsonEncode(eventEntity.toMap()),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 699,
            headers: headers));
    printRes(response);
    if (response.statusCode == 201) {
      return EventModel.fromJson(response.data);
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }





  @override
  Future<EventEntity> editEvent(EventEntity eventEntity) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.patch(Endpoints.editEvent.getPath(params: [eventEntity.id]),
        data: jsonEncode(eventEntity.toMap()),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 699,
            headers: headers));
    printRes(response);
    if (response.statusCode == 200) {
      return EventModel.fromJson(response.data);
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }





  @override
  Future<void> deleteEvent(List<int> ids) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.delete(Endpoints.deleteEvent.getPath(),
        data: jsonEncode({
          'event_list': ids
        }),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 699,
            headers: headers));
    printRes(response);
    if (response.statusCode == 204 || response.statusCode == 200) {
      return;
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }
}
