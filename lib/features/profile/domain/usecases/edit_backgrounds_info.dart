import 'package:be_loved/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/back_entity.dart';

class EditBackgroundsInfo implements UseCase<void, EditBackgroundsInfoParams> {
  final ProfileRepository repository;
  EditBackgroundsInfo(this.repository);

  @override
  Future<Either<Failure, void>> call(EditBackgroundsInfoParams params) async {
    return await repository.editBackgroundsInfo(params);
  }
}

class EditBackgroundsInfoParams extends Equatable {
  final BackEntity back;
  final String? filePath;
  const EditBackgroundsInfoParams({required this.back, required this.filePath});

  @override
  List<Object> get props => [back];
}