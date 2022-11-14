import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/domain/usecases/add_event.dart';
import 'package:dartz/dartz.dart';

abstract class EventsRepository {
  Future<Either<Failure, List<EventEntity>>> getEvents();
  Future<Either<Failure, bool>> addEvent(AddEventParams eventEntity);
}