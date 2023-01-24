import 'package:be_loved/features/home/domain/repositories/archive_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddFavorites implements UseCase<void, AddFavoritesParams> {
  final ArchiveRepository repository;

  AddFavorites(this.repository);

  @override
  Future<Either<Failure, void>> call(AddFavoritesParams params) async {
    return await repository.addFavoites(params);
  }
}

class AddFavoritesParams extends Equatable {
  final int fileId;
  final bool isFavor;
  const AddFavoritesParams({required this.fileId, required this.isFavor});

  @override
  List<Object> get props => [fileId, isFavor];
}