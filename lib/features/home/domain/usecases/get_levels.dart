import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/entities/home/levels_entiti.dart';
import 'package:be_loved/features/home/domain/repositories/main_widgets_repository.dart';
import 'package:dartz/dartz.dart';

class GetLevels extends UseCase<List<LevelEntiti>, NoParams>{
  final MainWidgetsRepository mainWidgetsRepository;

  GetLevels({required this.mainWidgetsRepository});
  @override
  Future<Either<Failure, List<LevelEntiti>>> call(NoParams params) async {
    return await mainWidgetsRepository.getLevels();
  }

}