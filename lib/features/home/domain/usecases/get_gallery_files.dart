import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/repositories/archive_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetGalleryFiles implements UseCase<List<GalleryFileEntity>, int> {
  final ArchiveRepository repository;

  GetGalleryFiles(this.repository);

  @override
  Future<Either<Failure, List<GalleryFileEntity>>> call(int params) async {
    return await repository.getGalleryFiles(params);
  }
}