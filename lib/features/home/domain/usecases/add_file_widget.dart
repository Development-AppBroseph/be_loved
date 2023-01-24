import 'package:be_loved/features/home/domain/repositories/main_widgets_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddFileWidget implements UseCase<void, AddFileWidgetParams> {
  final MainWidgetsRepository repository;

  AddFileWidget(this.repository);

  @override
  Future<Either<Failure, void>> call(AddFileWidgetParams params) async {
    return await repository.addFileWidget(params);
  }
}

class AddFileWidgetParams extends Equatable {
  final int id;
  const AddFileWidgetParams({required this.id});

  @override
  List<Object> get props => [id];
}