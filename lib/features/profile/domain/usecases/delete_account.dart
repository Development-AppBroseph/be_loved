import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class DeleteAccount extends UseCase<void, NoParams> {
  final ProfileRepository profileRepository;

  DeleteAccount({required this.profileRepository});
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await profileRepository.deleteAccount();
  }
}
