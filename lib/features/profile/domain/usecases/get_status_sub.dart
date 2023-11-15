import 'package:be_loved/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

import 'package:be_loved/core/error/failures.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/subscription_entiti.dart';

class GetStatusSub implements UseCase<SubEntiti, NoParams> {
  final ProfileRepository profileRepository;

  GetStatusSub({required this.profileRepository});
  @override
  Future<Either<Failure, SubEntiti>> call(NoParams params) async {
    return await profileRepository.getStatus();
  }
}
