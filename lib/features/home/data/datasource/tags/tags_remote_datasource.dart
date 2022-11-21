import 'dart:convert';
import 'package:be_loved/core/utils/helpers/dio_helper.dart';
import 'package:be_loved/features/home/data/models/events/tag_model.dart';
import 'package:be_loved/features/home/domain/entities/events/tag_entity.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/database/auth_params.dart';
import '../../../../../core/services/network/endpoints.dart';
import '../../../../../locator.dart';

abstract class TagsRemoteDataSource {
  Future<List<TagEntity>> getTags();
  Future<TagEntity> addTag(TagEntity tagEntity);
  Future<TagEntity> editTag(TagEntity tagEntity);
  Future<void> deleteTag(int id);

}

class TagsRemoteDataSourceImpl
    implements TagsRemoteDataSource {
  final Dio dio;

  TagsRemoteDataSourceImpl({required this.dio});
  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json"
  };


  @override
  Future<List<TagEntity>> getTags() async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.get(Endpoints.getTags.getPath(),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 499,
            headers: headers));
    printRes(response);
    if (response.statusCode == 200) {
      return (response.data as List)
            .map((json) => TagModel.fromJson(json))
            .toList();
    } else if(response.statusCode == 401){
      throw ServerException(message: 'token_error');
    }else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }



  @override
  Future<TagEntity> addTag(TagEntity tagEntity) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.post(Endpoints.addTag.getPath(),
        data: FormData.fromMap(tagEntity.toMap()),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 699,
            headers: headers));
    printRes(response);
    print('RES: ${response.statusCode}');
    print('RES: ${response.requestOptions.data}');
    if (response.statusCode == 201) {
      return TagModel.fromJson(response.data);
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }





  @override
  Future<TagEntity> editTag(TagEntity tagEntity) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.patch(Endpoints.editTag.getPath(params: [tagEntity.id]),
        data: jsonEncode(tagEntity.toMap()),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 699,
            headers: headers));
    printRes(response);
    if (response.statusCode == 200) {
      return TagModel.fromJson(response.data);
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }





  @override
  Future<void> deleteTag(int id) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.delete(Endpoints.deleteTag.getPath(params: [id]),
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
