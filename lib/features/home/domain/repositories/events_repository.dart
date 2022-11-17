import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/domain/usecases/add_event.dart';
import 'package:be_loved/features/home/domain/usecases/change_position_event.dart';
import 'package:be_loved/features/home/domain/usecases/delete_event.dart';
import 'package:be_loved/features/home/domain/usecases/edit_event.dart';
import 'package:dartz/dartz.dart';

abstract class EventsRepository {
  Future<Either<Failure, List<EventEntity>>> getEvents();
  Future<Either<Failure, EventEntity>> addEvent(AddEventParams params);
  Future<Either<Failure, EventEntity>> editEvent(EditEventParams params);
  Future<Either<Failure, void>> deleteEvent(DeleteEventParams params);
  Future<Either<Failure, void>> changePositionEvent(ChangePositionEventParams params);
}