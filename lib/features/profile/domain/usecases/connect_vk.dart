import 'package:be_loved/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class ConnectVK implements UseCase<String, ConnectVKParams> {
  final ProfileRepository repository;
  ConnectVK(this.repository);

  @override
  Future<Either<Failure, String>> call(ConnectVKParams params) async {
    return await repository.connectVK(params);
  }
}

class ConnectVKParams extends Equatable {
  final String code;
  const ConnectVKParams({required this.code});

  @override
  List<Object> get props => [code];
}