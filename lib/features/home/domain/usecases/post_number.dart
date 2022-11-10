import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/repositories/be_loved.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class PostNumber implements UseCase<void, EndpointParams>{
  final BelovedRepository belovedRepository;

  PostNumber(this.belovedRepository);

  @override
  Future<Either<Failure, void>> call(EndpointParams params) async {
   return await belovedRepository.postNumber(phoneNumber: params.phoneNumber);
  }

}


class EndpointParams extends Equatable {
  final String phoneNumber;

  const EndpointParams({
    required this.phoneNumber,
  });
  @override
  List<Object?> get props => [phoneNumber];
}