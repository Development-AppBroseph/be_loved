import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/entities/purposes/promos_entiti.dart';
import 'package:be_loved/features/home/domain/repositories/purpose_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetPromo extends UseCase<List<PromosEntiti>, PromosParams> {
  final PurposeRepository purposeRepository;

  GetPromo({required this.purposeRepository});
  @override
  Future<Either<Failure, List<PromosEntiti>>> call(PromosParams params) async {
    return await purposeRepository.getPromos();
  }
}

class PromosParams extends Equatable {
  @override
  List<Object?> get props => [];
}
