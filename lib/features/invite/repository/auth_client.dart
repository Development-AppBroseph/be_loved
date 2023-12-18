import 'package:be_loved/core/domain/object/single_response_body.dart';
import 'package:be_loved/features/invite/domain/models/joker_entity.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory AuthClient(Dio dio, {String? baseUrl}) = _AuthClient;

  @POST('/relations/joker')
  Future<HttpResponse<SingleResponseBody<JokerEntity>>> putJoker();

  @GET('/relations/joker')
  Future<HttpResponse<SingleResponseBody<JokerEntity>>> getJoker();
}
