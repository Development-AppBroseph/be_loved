import 'package:be_loved/features/home/domain/entities/statics/statics_entity.dart';
import 'package:be_loved/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetStatics implements UseCase<StaticsEntity, NoParams> {
  final ProfileRepository repository;
  GetStatics(this.repository);

  @override
  Future<Either<Failure, StaticsEntity>> call(NoParams params) async {
    return await repository.getStats();
  }
}
