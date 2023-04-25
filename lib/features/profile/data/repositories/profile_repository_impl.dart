import 'dart:io';

import 'package:be_loved/core/services/network/network_info.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/home/domain/entities/statics/statics_entity.dart';
import 'package:be_loved/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:be_loved/features/profile/domain/entities/back_entity.dart';
import 'package:be_loved/features/profile/domain/entities/subscription_entiti.dart';
import 'package:be_loved/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import '../../../../core/error/failures.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  ProfileRepositoryImpl(this.remoteDataSource, this.networkInfo);

  @override
  Future<Either<Failure, User>> editProfile(params) async {
    if (await networkInfo.isConnected) {
      try {
        final items =
            await remoteDataSource.editProfile(params.user, params.file);
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
        final items = await remoteDataSource.editRelation(
            params.relationId, params.nameRelation, params.date);
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
  Future<Either<Failure, StaticsEntity>> getStats() async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getStats();
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
  Future<Either<Failure, String>> connectVK(params) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.connectVK(params.code);
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
  Future<Either<Failure, void>> sendFilesToMail(params) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.sendFilesToMail(
            params.email, params.isParting);
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
  Future<Either<Failure, BackEntity>> getBackgroundsInfo() async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getBackgroundInfo();
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
  Future<Either<Failure, void>> editBackgroundsInfo(params) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.editBackgroundInfo(params.back,
            params.filePath == null ? null : File(params.filePath!));
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
  Future<Either<Failure, SubEntiti>> getStatus() async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getStatusSub();
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
  Future<Either<Failure, UserAnswer>> notification() async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.notification();
        return Right(data);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    if (await networkInfo.isConnected) {
      try {
        final data = await remoteDataSource.deleteAccount();
        return Right(data);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
