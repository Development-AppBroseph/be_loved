import 'dart:io';
import 'package:be_loved/features/home/domain/entities/archive/album_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/repositories/archive_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class CreateAlbum implements UseCase<void, CreateAlbumParams> {
  final ArchiveRepository repository;

  CreateAlbum(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateAlbumParams params) async {
    return await repository.createAlbum(params);
  }
}

class CreateAlbumParams extends Equatable {
  final AlbumEntity albumEntity;
  const CreateAlbumParams({required this.albumEntity });

  @override
  List<Object> get props => [albumEntity];
}