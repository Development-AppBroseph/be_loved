import 'package:be_loved/core/services/network/network_info.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:be_loved/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';


class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  ProfileRepositoryImpl(
      this.remoteDataSource, this.networkInfo);

  @override
  Future<Either<Failure, User>> editProfile(params) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.editProfile(params.user, params.file);
        return Right(items);
      } catch (e) {
        print(e);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }





  @override
  Future<Either<Failure, String>> editRelation(params) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.editRelation(params.relationId, params.nameRelation, params.theme);
        return Right(items);
      } catch (e) {
        print(e);
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}

