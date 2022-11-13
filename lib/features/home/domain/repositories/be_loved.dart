import 'package:be_loved/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class BelovedRepository{
  Future<Either<Failure, void>> postNumber({required String phoneNumber,});
  Future<Either<Failure, void>> putCode({required int code});
}