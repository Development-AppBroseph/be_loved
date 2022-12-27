import 'package:be_loved/features/home/domain/repositories/purpose_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class SendPhotoPurpose implements UseCase<void, SendPhotoPurposeParams> {
  final PurposeRepository repository;

  SendPhotoPurpose(this.repository);

  @override
  Future<Either<Failure, void>> call(SendPhotoPurposeParams params) async {
    return await repository.sendPhotoPurpose(params);
  }
}



class SendPhotoPurposeParams extends Equatable {
  final String path;
  final int target;

  const SendPhotoPurposeParams( {
    required this.path,
    required this.target,
  });
  @override
  List<Object?> get props => [path, target];
}