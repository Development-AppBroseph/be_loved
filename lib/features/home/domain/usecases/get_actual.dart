import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/entities/purposes/actual_entiti.dart';
import 'package:be_loved/features/home/domain/repositories/purpose_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetActual extends UseCase<List<ActualEntiti>, ActualParams> {
  final PurposeRepository purposeRepository;

  GetActual({required this.purposeRepository});
  @override
  Future<Either<Failure, List<ActualEntiti>>> call(ActualParams params) async {
    return await purposeRepository.getActuail();
  }
}

class ActualParams extends Equatable {
  @override
  List<Object?> get props => [];
}
