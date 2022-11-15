import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/domain/repositories/events_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddEvent implements UseCase<EventEntity, AddEventParams> {
  final EventsRepository repository;

  AddEvent(this.repository);

  @override
  Future<Either<Failure, EventEntity>> call(AddEventParams params) async {
    return await repository.addEvent(params);
  }
}

class AddEventParams extends Equatable {
  final EventEntity eventEntity;
  const AddEventParams({required this.eventEntity});

  @override
  List<Object> get props => [eventEntity];
}