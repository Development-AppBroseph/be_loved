import 'package:be_loved/core/error/exceptions.dart';
import 'package:be_loved/core/services/network/network_info.dart';
import 'package:be_loved/features/home/data/datasource/archive/archive_remote_datasource.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/memory_entity.dart';
import 'package:be_loved/features/home/domain/repositories/archive_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';


class ArchiveRepositoryImpl implements ArchiveRepository {
  final ArchiveRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  ArchiveRepositoryImpl(
      this.remoteDataSource, this.networkInfo);




  @override
  Future<Either<Failure, List<GalleryFileEntity>>> getGalleryFiles(int page) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getGalleryFiles(page);
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
  Future<Either<Failure, GalleryFileEntity>> addGalleryFile(params) async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.addGalleryFile(params.galleryFileEntity, params.file);
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
  Future<Either<Failure, MemoryEntity>> getMemoryInfo() async {
    if (await networkInfo.isConnected) {
      try {
        final items = await remoteDataSource.getMemoryInfo();
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

