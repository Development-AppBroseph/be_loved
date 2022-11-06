import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'constants/main_config_app.dart';
import 'core/services/database/auth_params.dart';
import 'core/services/network/config.dart';
import 'core/services/network/network_info.dart';

final sl = GetIt.instance;

void setupInjections() {
  //Main config of system
  sl.registerLazySingleton<MainConfigApp>(() => MainConfigApp());

  //! External
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  sl.registerFactory<Dio>(
    () => Dio(BaseOptions(baseUrl: Config.url.url)),
  );

  ///Authentication
  sl.registerLazySingleton<AuthConfig>(() => AuthConfig());
  // //Datasources
  // sl.registerLazySingleton<AuthenticationRemoteDataSource>(
  //   () => AuthenticationRemoteDataSourceImpl(dio: sl()),
  // );
  // sl.registerLazySingleton<AuthenticationLocalDataSource>(
  //   () => AuthenticationLocalDataSourceImpl(),
  // );

  // // //Repositories
  // sl.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(sl(), sl(), sl()),
  // );

  // // //UseCases
  // sl.registerLazySingleton(() => SendCodeResetPassword(sl()));

  // //Blocs
  // sl.registerFactory<AuthBloc>(
  //   () => AuthBloc(sl(), sl(), sl(), sl(), sl()),
  // );
}
