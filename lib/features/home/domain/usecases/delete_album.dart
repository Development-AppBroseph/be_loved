import 'dart:io';
import 'package:be_loved/features/home/domain/entities/archive/album_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/repositories/archive_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteAlbum implements UseCase<void, DeleteAlbumParams> {
  final ArchiveRepository repository;

  DeleteAlbum(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteAlbumParams params) async {
    return await repository.deleteAlbum(params);
  }
}

class DeleteAlbumParams extends Equatable {
  final AlbumEntity albumEntity;
  const DeleteAlbumParams({required this.albumEntity });

  @override
  List<Object> get props => [albumEntity];
}