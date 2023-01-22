import 'package:be_loved/features/home/domain/repositories/main_widgets_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteFileWidget implements UseCase<void, DeleteFileWidgetParams> {
  final MainWidgetsRepository repository;

  DeleteFileWidget(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteFileWidgetParams params) async {
    return await repository.deleteFileWidget(params);
  }
}

class DeleteFileWidgetParams extends Equatable {
  final int id;
  const DeleteFileWidgetParams({required this.id});

  @override
  List<Object> get props => [id];
}