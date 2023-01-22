import 'package:be_loved/features/profile/domain/entities/back_entity.dart';
import 'package:be_loved/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetBackgroundsInfo implements UseCase<BackEntity, NoParams> {
  final ProfileRepository repository;
  GetBackgroundsInfo(this.repository);

  @override
  Future<Either<Failure, BackEntity>> call(NoParams params) async {
    return await repository.getBackgroundsInfo();
  }
}
