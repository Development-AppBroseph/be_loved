import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/features/home/domain/repositories/be_loved.dart';
import 'package:dartz/dartz.dart';

class BelovedRepositoryImplement implements BelovedRepository{
  final BelovedRepository belovedRepository;

  BelovedRepositoryImplement(this.belovedRepository);
  @override
  Future<Either<Failure, void>> postNumber({required String phoneNumber}) async {
    return await _postNumber(() => belovedRepository.postNumber(phoneNumber: phoneNumber));
  }
  Future<Either<Failure, void>> _postNumber(Future<void> Function() number) async {
    try {
      final postNumber = await number();
      return Right(postNumber);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}