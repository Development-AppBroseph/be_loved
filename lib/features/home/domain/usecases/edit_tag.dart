import 'package:be_loved/features/home/domain/entities/events/tag_entity.dart';
import 'package:be_loved/features/home/domain/repositories/tags_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class EditTag implements UseCase<TagEntity, EditTagParams> {
  final TagsRepository repository;

  EditTag(this.repository);

  @override
  Future<Either<Failure, TagEntity>> call(EditTagParams params) async {
    return await repository.editTag(params);
  }
}

class EditTagParams extends Equatable {
  final TagEntity tagEntity;
  const EditTagParams({required this.tagEntity});

  @override
  List<Object> get props => [tagEntity];
}