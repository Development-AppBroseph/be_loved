import 'package:be_loved/features/home/domain/entities/events/tag_entity.dart';
import 'package:be_loved/features/home/domain/repositories/tags_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddTag implements UseCase<TagEntity, AddTagParams> {
  final TagsRepository repository;

  AddTag(this.repository);

  @override
  Future<Either<Failure, TagEntity>> call(AddTagParams params) async {
    return await repository.addTag(params);
  }
}

class AddTagParams extends Equatable {
  final TagEntity tagEntity;
  const AddTagParams({required this.tagEntity});

  @override
  List<Object> get props => [tagEntity];
}