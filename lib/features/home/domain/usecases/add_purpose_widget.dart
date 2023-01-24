import 'package:be_loved/features/home/domain/repositories/main_widgets_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddPurposeWidget implements UseCase<void, AddPurposeWidgetParams> {
  final MainWidgetsRepository repository;

  AddPurposeWidget(this.repository);

  @override
  Future<Either<Failure, void>> call(AddPurposeWidgetParams params) async {
    return await repository.addPurposeWidget(params);
  }
}

class AddPurposeWidgetParams extends Equatable {
  final int id;
  const AddPurposeWidgetParams({required this.id});

  @override
  List<Object> get props => [id];
}