import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/features/home/domain/entities/archive/album_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/memory_entity.dart';
import 'package:be_loved/features/home/domain/usecases/add_gallery_file.dart';
import 'package:be_loved/features/home/domain/usecases/create_album.dart';
import 'package:be_loved/features/home/domain/usecases/delete_album.dart';
import 'package:dartz/dartz.dart';

abstract class ArchiveRepository {
  Future<Either<Failure, List<GalleryFileEntity>>> getGalleryFiles(int page);
  Future<Either<Failure, void>> deleteGalleryFiles(List<int> ids);
  Future<Either<Failure, void>> addGalleryFile(AddGalleryFileParams params);
  Future<Either<Failure, MemoryEntity>> getMemoryInfo();

  Future<Either<Failure, List<AlbumEntity>>> getAlbums();
  Future<Either<Failure, void>> createAlbum(CreateAlbumParams params);
  Future<Either<Failure, void>> deleteAlbum(DeleteAlbumParams params);
}