import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/my_app/models/image_model.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class Datasource {
  Dio _dio = Dio();
  Datasource() {
    _dio = Dio(
      BaseOptions(baseUrl: Config.url.url),
    );
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }
  Future<ImageModel> initialPhoto() async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final time = formatter.format(DateTime.now());
    try {
      final Response response = await _dio.get(
        '/hello_images/hello',
        queryParameters: {'date': time},
      );
      return ImageModel.fromJson(response.data);
    } on DioError catch (error) {
      if (error.response?.statusCode == 400) {
        throw 'На этот день нчего нет(';
      }
      throw error.response?.data;
    }
  }
}
