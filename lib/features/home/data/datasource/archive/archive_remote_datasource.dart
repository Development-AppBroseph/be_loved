import 'dart:convert';
import 'dart:io';
import 'package:be_loved/core/utils/helpers/dio_helper.dart';
import 'package:be_loved/features/home/data/models/archive/album_model.dart';
import 'package:be_loved/features/home/data/models/archive/gallery_file_model.dart';
import 'package:be_loved/features/home/data/models/archive/memory_model.dart';
import 'package:be_loved/features/home/domain/entities/archive/album_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/memory_entity.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/database/auth_params.dart';
import '../../../../../core/services/network/endpoints.dart';
import '../../../../../locator.dart';

abstract class ArchiveRemoteDataSource {
  Future<List<GalleryFileEntity>> getGalleryFiles(int page);
  Future<void> deleteGalleryFiles(List<int> ids);
  Future<void> addGalleryFile(List<GalleryFileEntity> galleryFileEntity,);
  Future<MemoryEntity> getMemoryInfo();

  //Albums
  Future<List<AlbumEntity>> getAlbums();
  Future<void> createAlbum(AlbumEntity albumEntity);
  Future<void> deleteAlbum(AlbumEntity albumEntity);
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
    headers["Content-Type"] = "application/json";
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
  Future<List<AlbumEntity>> getAlbums() async {
    headers["Content-Type"] = "application/json";
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.get(Endpoints.getAlbums.getPath(),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    if (response.statusCode == 200) {
      return (response.data as List)
            .map((json) => AlbumModel.fromJson(json))
            .toList();
    } else if(response.statusCode == 401){
      throw ServerException(message: 'token_error');
    }else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }





  @override
  Future<void> deleteGalleryFiles(List<int> ids) async {
    print('DELETE IDS: ${ids}');
    headers["Content-Type"] = "application/json";
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.delete(Endpoints.deleteGalleryFiles.getPath(),
        data: jsonEncode({'file_list': ids}),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 599,
            headers: headers));
    printRes(response);
    if (!(response.statusCode! < 200 || response.statusCode! > 204)) {
      return;
    } else if(response.statusCode == 401){
      throw ServerException(message: 'token_error');
    }else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }



  @override
  Future<void> createAlbum(AlbumEntity albumEntity) async {
    headers["Content-Type"] = "application/json";
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.post(Endpoints.createAlbum.getPath(),
        data: FormData.fromMap(albumEntity.toMap()),
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
  Future<void> deleteAlbum(AlbumEntity albumEntity) async {
    headers["Content-Type"] = "application/json";
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.delete(Endpoints.deleteAlbum.getPath(params: [albumEntity.id]),
        data: FormData.fromMap(albumEntity.toMap()),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 699,
            headers: headers));
    printRes(response);
    if (!(response.statusCode! < 200 || response.statusCode! > 204)) {
      return;
    } else {
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
    List<MultipartFile?> images = [];
    List<DateTime> times = [];
    List<String?> places = [];
    List<int> durations = [];
    final String path = (await getApplicationDocumentsDirectory()).path;
    for(int i = 0; i < list.length; i++){
      files.add(await MultipartFile.fromFile(list[i].urlToFile));
      places.add(list[i].place);
      times.add(list[i].dateTime);
      durations.add(list[i].duration ?? 0);
      File? newFile;
      if(list[i].memoryFilePhotoForVideo != null){
        final int epoch = DateTime.now().millisecondsSinceEpoch;
        newFile = await File('$path/image_$epoch.jpeg').create();
        newFile.writeAsBytesSync(list[i].memoryFilePhotoForVideo!);
      }
      images.add(list[i].memoryFilePhotoForVideo == null ? null : (await MultipartFile.fromFile(newFile!.path)));
    }
    Map<String, dynamic> mapDataList = {
      'files': files,
      'places': places,
      'dates': times,
      // 'images': images,
      'durations': durations
    };
    for(int i = 0; i < images.length; i++){
      mapDataList.addAll({'image_$i': [images[i] ?? '0']});
    }
    print('mapDATA: ${mapDataList}');
    Response response = await dio.post(Endpoints.addGalleryFile.getPath(),
        data: FormData.fromMap(mapDataList),
        options: Options(
            sendTimeout: 240000,
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
