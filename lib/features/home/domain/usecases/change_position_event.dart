import 'package:be_loved/features/home/domain/repositories/events_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class ChangePositionEvent implements UseCase<void, ChangePositionEventParams> {
  final EventsRepository repository;

  ChangePositionEvent(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangePositionEventParams params) async {
    return await repository.changePositionEvent(params);
  }
}

class ChangePositionEventParams extends Equatable {
  final Map<String, int> items;
  const ChangePositionEventParams({required this.items});

  @override
  List<Object> get props => [items];
}