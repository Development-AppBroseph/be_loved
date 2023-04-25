import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class Notification extends UseCase<UserAnswer, NoParams>{
  final ProfileRepository profileRepository;

  Notification({required this.profileRepository});

  @override
  Future<Either<Failure, UserAnswer>> call(NoParams params) async {
    return await profileRepository.notification();
  }
}