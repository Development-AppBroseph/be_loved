import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/repositories/be_loved.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class PutCode implements UseCase<void, CodeParams>{
  final BelovedRepository belovedRepository;

  PutCode(this.belovedRepository);

  @override
  Future<Either<Failure, void>> call(CodeParams params) async {
    return await belovedRepository.putCode(code: params.code);
  }
  
}


class CodeParams extends Equatable{
  final int code;

  const CodeParams({required this.code});
  @override
  List<Object?> get props => [code];
}