import 'package:be_loved/core/error/exceptions.dart';
import 'package:be_loved/core/services/network/network_info.dart';
import 'package:be_loved/features/home/data/datasource/purpose/purpose_remote_datasource.dart';
import 'package:be_loved/features/home/domain/entities/purposes/full_purpose_entity.dart';
import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:be_loved/features/home/domain/repositories/purpose_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';


class PurposeRepositoryImpl implements PurposeRepository {
  final PurposeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  PurposeRepositoryImpl(
      this.remoteDataSource, this.networkInfo);




  @override
  Future<Either<Failure, List<PurposeEntity>>> getAvailablePurposes(params) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getAvailablePurposes(params.lat, params.long);
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
  Future<Either<Failure, List<FullPurposeEntity>>> getInProcessPurposes() async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getInProcessPurposes();
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
  Future<Either<Failure, void>> completePurpose(params) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.completePurpose(params.target);
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
  Future<Either<Failure, PurposeEntity>> getSeasonPurpose() async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getSeasonPurpose();
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

