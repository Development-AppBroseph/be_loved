import 'package:be_loved/core/error/exceptions.dart';
import 'package:be_loved/core/services/network/network_info.dart';
import 'package:be_loved/features/home/data/datasource/tags/tags_remote_datasource.dart';
import 'package:be_loved/features/home/domain/entities/events/tag_entity.dart';
import 'package:be_loved/features/home/domain/repositories/tags_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';


class TagsRepositoryImpl implements TagsRepository {
  final TagsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  TagsRepositoryImpl(
      this.remoteDataSource, this.networkInfo);




  @override
  Future<Either<Failure, List<TagEntity>>> getTags() async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getTags();
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
  Future<Either<Failure, TagEntity>> addTag(params) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.addTag(params.tagEntity);
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






  // @override
  // Future<Either<Failure, TagEntity>> editTag(params) async {
  //   if (await networkInfo.isConnected) {
  //     try {
  //       final items = await remoteDataSource.editTag(params.eventEntity);
  //       return Right(items);
  //     } catch (e) {
  //       print(e);
  //       if(e is ServerException){
  //         return Left(ServerFailure(e.message ?? 'Ошибка сервера'));
  //       }
  //       return Left(ServerFailure(e.toString()));
  //     }
  //   } else {
  //     return Left(NetworkFailure());
  //   }
  // }






  // @override
  // Future<Either<Failure, void>> deleteTag(params) async {
  //   if (await networkInfo.isConnected) {
  //     try {
  //       final items = await remoteDataSource.deleteTag(params.ids);
  //       return Right(items);
  //     } catch (e) {
  //       print(e);
  //       if(e is ServerException){
  //         return Left(ServerFailure(e.message ?? 'Ошибка сервера'));
  //       }
  //       return Left(ServerFailure(e.toString()));
  //     }
  //   } else {
  //     return Left(NetworkFailure());
  //   }
  // }
}

