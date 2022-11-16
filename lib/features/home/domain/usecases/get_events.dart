import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/domain/repositories/events_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetEvents implements UseCase<List<EventEntity>, NoParams> {
  final EventsRepository repository;

  GetEvents(this.repository);

  @override
  Future<Either<Failure, List<EventEntity>>> call(NoParams params) async {
    return await repository.getEvents();
  }
}