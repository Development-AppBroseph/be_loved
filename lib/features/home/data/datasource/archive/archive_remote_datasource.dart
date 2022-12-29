import 'dart:convert';
import 'dart:io';
import 'package:be_loved/core/utils/helpers/dio_helper.dart';
import 'package:be_loved/features/home/data/models/archive/gallery_file_model.dart';
import 'package:be_loved/features/home/data/models/archive/memory_model.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/memory_entity.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/database/auth_params.dart';
import '../../../../../core/services/network/endpoints.dart';
import '../../../../../locator.dart';

abstract class ArchiveRemoteDataSource {
  Future<List<GalleryFileEntity>> getGalleryFiles(int page);
  Future<void> addGalleryFile(List<GalleryFileEntity> galleryFileEntity,);
  Future<MemoryEntity> getMemoryInfo();

  
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
  Future<void> addGalleryFile(List<GalleryFileEntity> list) async {
    print('DATA: ${list.length}');
    headers["Content-Type"] = "multipart/form-data";
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    // Map<String, Map<String, dynamic>> mapDataList = {};
    // for(int i = 0; i < list.length; i++){
    //   mapDataList.addAll({i.toString(): await list[i].toMap()});
    // }
    List<MultipartFile> files = [];
    List<DateTime> times = [];
    List<String?> places = [];
    for(int i = 0; i < list.length; i++){
      files.add(await MultipartFile.fromFile(list[i].urlToFile));
      places.add(list[i].place);
      times.add(list[i].dateTime);
    }
    Map<String, dynamic> mapDataList = {
      'files': files,
      'places': places,
      'dates': times
    };
    print('mapDATA: ${mapDataList}');
    Response response = await dio.post(Endpoints.addGalleryFile.getPath(),
        data: FormData.fromMap(mapDataList),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 699,
            headers: headers));
    printRes(response);
    if (response.statusCode == 201) {
      return;
    } else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }




  @override
  Future<MemoryEntity> getMemoryInfo() async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.get(Endpoints.getSizeOfMemory.getPath(),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    if (response.statusCode == 200) {
      MemoryEntity memoryEntity = MemoryModel.fromJson(response.data);
      sl<AuthConfig>().memoryEntity = memoryEntity;
      return memoryEntity;
    } else if(response.statusCode == 401){
      throw ServerException(message: 'token_error');
    }else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }



}
