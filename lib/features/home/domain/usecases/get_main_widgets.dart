import 'package:be_loved/features/home/domain/entities/main_widgets/main_widgets_entity.dart';
import 'package:be_loved/features/home/domain/repositories/main_widgets_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetMainWidgets implements UseCase<MainWidgetsEntity, NoParams> {
  final MainWidgetsRepository repository;

  GetMainWidgets(this.repository);

  @override
  Future<Either<Failure, MainWidgetsEntity>> call(NoParams params) async {
    return await repository.getMainWidgets();
  }
}