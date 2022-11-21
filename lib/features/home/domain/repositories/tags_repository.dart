import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/features/home/domain/entities/events/tag_entity.dart';
import 'package:be_loved/features/home/domain/usecases/add_tag.dart';
import 'package:be_loved/features/home/domain/usecases/delete_tag.dart';
import 'package:be_loved/features/home/domain/usecases/edit_tag.dart';
import 'package:dartz/dartz.dart';

abstract class TagsRepository {
  Future<Either<Failure, List<TagEntity>>> getTags();
  Future<Either<Failure, TagEntity>> addTag(AddTagParams params);
  Future<Either<Failure, TagEntity>> editTag(EditTagParams params);
  Future<Either<Failure, void>> deleteTag(DeleteTagParams params);
}