import 'package:data_source/dto/dto.dart';

abstract base class GeneralResponseBody<T> implements DTO {
  bool? success;
  String? message;
  T? data;
  Map<String, List<String>>? errors;

  GeneralResponseBody({
    this.success,
    this.data,
    this.message,
    this.errors,
  });
}
