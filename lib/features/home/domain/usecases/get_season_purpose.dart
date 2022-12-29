import 'package:be_loved/features/home/domain/entities/purposes/full_purpose_entity.dart';
import 'package:be_loved/features/home/domain/repositories/purpose_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetSeasonPurpose implements UseCase<FullPurposeEntity, NoParams> {
  final PurposeRepository repository;

  GetSeasonPurpose(this.repository);

  @override
  Future<Either<Failure, FullPurposeEntity>> call(NoParams params) async {
    return await repository.getSeasonPurpose();
  }
}