import 'package:be_loved/features/home/domain/entities/archive/memory_entity.dart';
import 'package:be_loved/features/home/domain/repositories/archive_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetMemoryInfo implements UseCase<MemoryEntity, NoParams> {
  final ArchiveRepository repository;
  GetMemoryInfo(this.repository);

  @override
  Future<Either<Failure, MemoryEntity>> call(NoParams params) async {
    return await repository.getMemoryInfo();
  }
}