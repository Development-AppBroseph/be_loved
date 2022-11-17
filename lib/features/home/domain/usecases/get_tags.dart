import 'package:be_loved/features/home/domain/entities/events/tag_entity.dart';
import 'package:be_loved/features/home/domain/repositories/tags_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetTags implements UseCase<List<TagEntity>, NoParams> {
  final TagsRepository repository;

  GetTags(this.repository);

  @override
  Future<Either<Failure, List<TagEntity>>> call(NoParams params) async {
    return await repository.getTags();
  }
}