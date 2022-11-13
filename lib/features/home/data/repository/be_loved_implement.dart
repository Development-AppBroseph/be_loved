import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/features/home/data/datasource/be_loved_remote_datasource.dart';
import 'package:be_loved/features/home/domain/repositories/be_loved.dart';
import 'package:dartz/dartz.dart';

class BelovedRepositoryImplement implements BelovedRepository {
  final BeLovedRemoteDatasource beLovedRemoteDatasource;

  BelovedRepositoryImplement(this.beLovedRemoteDatasource);
  @override
  Future<Either<Failure, void>> postNumber({
    required String phoneNumber,
  }) async {
    return await _postNumber(() => beLovedRemoteDatasource.postNumber(
          phoneNumber: phoneNumber,
        ));
  }

  Future<Either<Failure, void>> _postNumber(
      Future<void> Function() number) async {
    try {
      final postNumber = await number();
      return Right(postNumber);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> putCode({required int code}) async {
    return await _putCode(
      () => beLovedRemoteDatasource.putCode(
        code: code,
      ),
    );
  }

  Future<Either<Failure, void>> _putCode(Future<void> Function() code) async {
    try {
      final putCode = await code();
      return Right(putCode);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
