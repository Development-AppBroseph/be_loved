import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/features/home/domain/entities/purposes/actual_entiti.dart';
import 'package:be_loved/features/home/domain/entities/purposes/full_purpose_entity.dart';
import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:be_loved/features/home/domain/usecases/cancel_purpose.dart';
import 'package:be_loved/features/home/domain/usecases/complete_purpose.dart';
import 'package:be_loved/features/home/domain/usecases/send_photo_purpose.dart';
import 'package:dartz/dartz.dart';

import '../entities/purposes/promos_entiti.dart';
import '../usecases/get_available_purposes.dart';

abstract class PurposeRepository {
  Future<Either<Failure, List<PurposeEntity>>> getAvailablePurposes(
      GetAvailablePurposesParams params);
  Future<Either<Failure, List<FullPurposeEntity>>> getInProcessPurposes();
  Future<Either<Failure, List<FullPurposeEntity>>> getHistoryPurposes();
  Future<Either<Failure, PurposeEntity>> getSeasonPurpose();
  Future<Either<Failure, void>> completePurpose(CompletePurposeParams params);
  Future<Either<Failure, void>> cancelPurpose(CancelPurposeParams params);
  Future<Either<Failure, void>> sendPhotoPurpose(SendPhotoPurposeParams params);
  Future<Either<Failure, List<PromosEntiti>>> getPromos();
  Future<Either<Failure, List<ActualEntiti>>> getActuail();
}
