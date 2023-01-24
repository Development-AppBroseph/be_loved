import 'package:be_loved/core/error/exceptions.dart';
import 'package:be_loved/core/services/network/network_info.dart';
import 'package:be_loved/features/home/data/datasource/main_widgets/main_widgets_remote_datasource.dart';
import 'package:be_loved/features/home/domain/entities/main_widgets/main_widgets_entity.dart';
import 'package:be_loved/features/home/domain/repositories/main_widgets_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';


class MainWidgetsRepositoryImpl implements MainWidgetsRepository {
  final MainWidgetsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  MainWidgetsRepositoryImpl(
      this.remoteDataSource, this.networkInfo);




  @override
  Future<Either<Failure, MainWidgetsEntity>> getMainWidgets() async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getMainWidgets();
        return Right(items);
      } catch (e) {
        print(e);
        if(e is ServerException){
          return Left(ServerFailure(e.message ?? 'Ошибка сервера'));
        }
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }



  @override
  Future<Either<Failure, void>> addFileWidget(params) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.addFileWidget(params.id);
        return Right(items);
      } catch (e) {
        print(e);
        if(e is ServerException){
          return Left(ServerFailure(e.message ?? 'Ошибка сервера'));
        }
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }






  @override
  Future<Either<Failure, void>> addPurposeWidget(params) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.addPurposeWidget(params.id);
        return Right(items);
      } catch (e) {
        print(e);
        if(e is ServerException){
          return Left(ServerFailure(e.message ?? 'Ошибка сервера'));
        }
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }






  @override
  Future<Either<Failure, void>> deletePurposeWidget(params) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.deletePurposeWidget(params.id);
        return Right(items);
      } catch (e) {
        print(e);
        if(e is ServerException){
          return Left(ServerFailure(e.message ?? 'Ошибка сервера'));
        }
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }





  @override
  Future<Either<Failure, void>> deleteFileWidget(params) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.deleteFileWidget(params.id);
        return Right(items);
      } catch (e) {
        print(e);
        if(e is ServerException){
          return Left(ServerFailure(e.message ?? 'Ошибка сервера'));
        }
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

}

