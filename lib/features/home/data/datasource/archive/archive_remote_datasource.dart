import 'dart:convert';
import 'dart:io';
import 'package:be_loved/core/utils/helpers/dio_helper.dart';
import 'package:be_loved/features/home/data/models/archive/gallery_file_model.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/database/auth_params.dart';
import '../../../../../core/services/network/endpoints.dart';
import '../../../../../locator.dart';

abstract class ArchiveRemoteDataSource {
  Future<List<GalleryFileEntity>> getGalleryFiles(int page);
  Future<GalleryFileEntity> addGalleryFile(GalleryFileEntity galleryFileEntity, File? file);
  // Future<EventEntity> editEvent(EventEntity eventEntity, File? photo, bool isDeletePhoto);
  // Future<void> deleteEvent(List<int> ids);
  // Future<void> homeChangePosition(Map<String, int> items);

}

class ArchiveRemoteDataSourceImpl
    implements ArchiveRemoteDataSource {
  final Dio dio;

  ArchiveRemoteDataSourceImpl({required this.dio});
  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json"
  };


  @override
  Future<List<GalleryFileEntity>> getGalleryFiles(int page) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.get(Endpoints.getGalleryFiles.getPath(),
        queryParameters: {
          'page': page
        },
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    if (response.statusCode == 200) {
      return (response.data as List)
            .map((json) => GalleryFileModel.fromJson(json))
            .toList();
    } else if(response.statusCode == 401){
      throw ServerException(message: 'token_error');
    }else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }



  @override
  Future<GalleryFileEntity> addGalleryFile(GalleryFileEntity galleryFileEntity, File? file) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.post(Endpoints.addGalleryFile.getPath(),
        data: jsonEncode(galleryFileEntity.toMap()),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 699,
            headers: headers));
    printRes(response);
    if (response.statusCode == 201) {
      return GalleryFileModel.fromJson(response.data);
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }
}
