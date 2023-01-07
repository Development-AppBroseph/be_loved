import 'package:be_loved/features/home/domain/entities/archive/album_entity.dart';
import 'package:be_loved/features/home/domain/repositories/archive_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAlbums implements UseCase<List<AlbumEntity>, NoParams> {
  final ArchiveRepository repository;

  GetAlbums(this.repository);

  @override
  Future<Either<Failure, List<AlbumEntity>>> call(NoParams params) async {
    return await repository.getAlbums();
  }
}