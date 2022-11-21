import 'package:be_loved/features/home/domain/entities/events/tag_entity.dart';
import 'package:be_loved/features/home/domain/repositories/tags_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteTag implements UseCase<void, DeleteTagParams> {
  final TagsRepository repository;

  DeleteTag(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteTagParams params) async {
    return await repository.deleteTag(params);
  }
}

class DeleteTagParams extends Equatable {
  final int id;
  const DeleteTagParams({required this.id});

  @override
  List<Object> get props => [id];
}