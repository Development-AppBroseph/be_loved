import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:be_loved/features/home/domain/repositories/purpose_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class CancelPurpose implements UseCase<void, CancelPurposeParams> {
  final PurposeRepository repository;

  CancelPurpose(this.repository);

  @override
  Future<Either<Failure, void>> call(CancelPurposeParams params) async {
    return await repository.cancelPurpose(params);
  }
}

class CancelPurposeParams extends Equatable {
  final int target;
  const CancelPurposeParams({required this.target});

  @override
  List<Object> get props => [target];
}