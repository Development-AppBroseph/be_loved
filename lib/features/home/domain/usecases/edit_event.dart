import 'dart:io';

import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/domain/repositories/events_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class EditEvent implements UseCase<EventEntity, EditEventParams> {
  final EventsRepository repository;

  EditEvent(this.repository);

  @override
  Future<Either<Failure, EventEntity>> call(EditEventParams params) async {
    return await repository.editEvent(params);
  }
}

class EditEventParams extends Equatable {
  final EventEntity eventEntity;
  final File? photo;
  final bool isDeletePhoto;
  const EditEventParams({required this.eventEntity, this.photo, this.isDeletePhoto = false});

  @override 
  List<Object> get props => [eventEntity];
}