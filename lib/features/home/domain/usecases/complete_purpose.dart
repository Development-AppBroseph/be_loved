import 'package:be_loved/features/home/domain/repositories/purpose_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class CompletePurpose implements UseCase<void, CompletePurposeParams> {
  final PurposeRepository repository;

  CompletePurpose(this.repository);

  @override
  Future<Either<Failure, void>> call(CompletePurposeParams params) async {
    return await repository.completePurpose(params);
  }
}

class CompletePurposeParams extends Equatable {
  final int target;
  const CompletePurposeParams({required this.target});

  @override
  List<Object> get props => [target];
}
