import 'package:be_loved/features/home/domain/repositories/main_widgets_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeletePurposeWidget implements UseCase<void, DeletePurposeWidgetParams> {
  final MainWidgetsRepository repository;

  DeletePurposeWidget(this.repository);

  @override
  Future<Either<Failure, void>> call(DeletePurposeWidgetParams params) async {
    return await repository.deletePurposeWidget(params);
  }
}

class DeletePurposeWidgetParams extends Equatable {
  final int id;
  const DeletePurposeWidgetParams({required this.id});

  @override
  List<Object> get props => [id];
}