import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/features/home/domain/entities/purposes/full_purpose_entity.dart';
import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:be_loved/features/home/domain/usecases/complete_purpose.dart';
import 'package:dartz/dartz.dart';

import '../usecases/get_available_purposes.dart';

abstract class PurposeRepository {
  Future<Either<Failure, List<PurposeEntity>>> getAvailablePurposes(GetAvailablePurposesParams params);
  Future<Either<Failure, List<FullPurposeEntity>>> getInProcessPurposes();
  Future<Either<Failure, PurposeEntity>> getSeasonPurpose();
  Future<Either<Failure, void>> completePurpose(CompletePurposeParams params);
}