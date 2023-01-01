import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/repositories/archive_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteGalleryFiles implements UseCase<void, List<int>> {
  final ArchiveRepository repository;

  DeleteGalleryFiles(this.repository);

  @override
  Future<Either<Failure, void>> call(List<int> params) async {
    return await repository.deleteGalleryFiles(params);
  }
}