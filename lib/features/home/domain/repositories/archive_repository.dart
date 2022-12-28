import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/memory_entity.dart';
import 'package:be_loved/features/home/domain/usecases/add_gallery_file.dart';
import 'package:dartz/dartz.dart';

abstract class ArchiveRepository {
  Future<Either<Failure, List<GalleryFileEntity>>> getGalleryFiles(int page);
  Future<Either<Failure, GalleryFileEntity>> addGalleryFile(AddGalleryFileParams params);
  Future<Either<Failure, MemoryEntity>> getMemoryInfo();
  // Future<Either<Failure, EventEntity>> editGalleryFile(EditEventParams params);
  // Future<Either<Failure, void>> deleteEvent(DeleteEventParams params);
  // Future<Either<Failure, void>> changePositionEvent(ChangePositionEventParams params);
}