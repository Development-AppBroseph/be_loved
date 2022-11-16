import 'package:be_loved/features/home/domain/repositories/events_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteEvent implements UseCase<void, DeleteEventParams> {
  final EventsRepository repository;

  DeleteEvent(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteEventParams params) async {
    return await repository.deleteEvent(params);
  }
}

class DeleteEventParams extends Equatable {
  final int id;
  const DeleteEventParams({required this.id});

  @override
  List<Object> get props => [id];
}