import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/domain/repositories/archive_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetOldEvents implements UseCase<List<EventEntity>, int> {
  final ArchiveRepository repository;

  GetOldEvents(this.repository);

  @override
  Future<Either<Failure, List<EventEntity>>> call(int params) async {
    return await repository.getOldEvents(params);
  }
}