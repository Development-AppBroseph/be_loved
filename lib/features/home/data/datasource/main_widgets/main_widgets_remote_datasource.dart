import 'package:be_loved/core/utils/helpers/dio_helper.dart';
import 'package:be_loved/features/home/data/models/archive/gallery_file_model.dart';
import 'package:be_loved/features/home/data/models/purposes/purpose_model.dart';
import 'package:be_loved/features/home/domain/entities/main_widgets/main_widgets_entity.dart';
import 'package:dio/dio.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/services/database/auth_params.dart';
import '../../../../../core/services/network/endpoints.dart';
import '../../../../../locator.dart';

abstract class MainWidgetsRemoteDataSource {
  Future<MainWidgetsEntity> getMainWidgets();
  Future<void> addFileWidget(int id);
  Future<void> addPurposeWidget(int id);
  Future<void> deleteFileWidget(int id);
  Future<void> deletePurposeWidget(int id);

}

class MainWidgetsRemoteDataSourceImpl
    implements MainWidgetsRemoteDataSource {
  final Dio dio;

  MainWidgetsRemoteDataSourceImpl({required this.dio});
  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json"
  };


  @override
  Future<MainWidgetsEntity> getMainWidgets() async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.get(Endpoints.getMainWidgets.getPath(),
        options: Options(
            followRedirects: false,
            validateStatus: (status) => status! < 499,
            headers: headers));
    printRes(response);
    if (response.statusCode == 200) {

      final file = response.data['file'] == null ? null : GalleryFileModel.fromJson(response.data['file']);
      final purposes = response.data['targets'] == null ? null : (response.data['targets'] as List)
            .map((json) => PurposeModel.fromJson(json))
            .toList();

      return MainWidgetsEntity(
        file: file, 
        purposes: purposes ?? []
      );
    } else if(response.statusCode == 401){
      throw ServerException(message: 'token_error');
    }else {
      throw ServerException(message: 'Ошибка с сервером');
    }
  }




  @override
  Future<void> addFileWidget(int id) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.post(Endpoints.addFileWidget.getPath(params: [id]),
        data: FormData.fromMap({
          'file': id
        }),
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
  Future<void> addPurposeWidget(int id) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.post(Endpoints.addPurposeWidget.getPath(params: [id]),
        data: FormData.fromMap({
          'target': id
        }),
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
  Future<void> deleteFileWidget(int id) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.delete(Endpoints.deleteFileWidget.getPath(params: [id]),
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
  Future<void> deletePurposeWidget(int id) async {
    headers["Authorization"] = "Token ${sl<AuthConfig>().token}";
    Response response = await dio.delete(Endpoints.deletePurposeWidget.getPath(params: [id]),
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
}
