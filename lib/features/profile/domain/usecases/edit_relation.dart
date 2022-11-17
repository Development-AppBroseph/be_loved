import 'package:be_loved/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class EditRelation implements UseCase<String, EditRelationParams> {
  final ProfileRepository repository;
  EditRelation(this.repository);

  @override
  Future<Either<Failure, String>> call(EditRelationParams params) async {
    return await repository.editRelation(params);
  }
}

class EditRelationParams extends Equatable {
  final int relationId;
  final String nameRelation;
  const EditRelationParams({required this.relationId, required this.nameRelation});

  @override
  List<Object> get props => [relationId, nameRelation];
}