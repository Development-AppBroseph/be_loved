import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:be_loved/features/home/domain/repositories/purpose_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAvailablePurposes implements UseCase<List<PurposeEntity>, GetAvailablePurposesParams> {
  final PurposeRepository repository;

  GetAvailablePurposes(this.repository);

  @override
  Future<Either<Failure, List<PurposeEntity>>> call(GetAvailablePurposesParams params) async {
    return await repository.getAvailablePurposes(params);
  }
}

class GetAvailablePurposesParams extends Equatable {
  final double lat;
  final double long;
  const GetAvailablePurposesParams({required this.lat, required this.long});

  @override
  List<Object> get props => [lat, long];
}