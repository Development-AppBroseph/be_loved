import 'package:be_loved/features/home/domain/entities/archive/moment_entity.dart';
import 'package:be_loved/features/home/domain/repositories/archive_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetMoments implements UseCase<MomentEntity, int> {
  final ArchiveRepository repository;

  GetMoments(this.repository);

  @override
  Future<Either<Failure, MomentEntity>> call(int params) async {
    return await repository.getMoments(params);
  }
}