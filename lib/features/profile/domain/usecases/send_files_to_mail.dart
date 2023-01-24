import 'package:be_loved/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class SendFilesToMail implements UseCase<void, SendFilesToMailParams> {
  final ProfileRepository repository;
  SendFilesToMail(this.repository);

  @override
  Future<Either<Failure, void>> call(SendFilesToMailParams params) async {
    return await repository.sendFilesToMail(params);
  }
}

class SendFilesToMailParams extends Equatable {
  final String email;
  final bool isParting;
  const SendFilesToMailParams({required this.email, required this.isParting});

  @override
  List<Object> get props => [email];
}