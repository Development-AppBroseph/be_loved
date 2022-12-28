import 'dart:io';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/repositories/archive_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class AddGalleryFile implements UseCase<GalleryFileEntity, AddGalleryFileParams> {
  final ArchiveRepository repository;

  AddGalleryFile(this.repository);

  @override
  Future<Either<Failure, GalleryFileEntity>> call(AddGalleryFileParams params) async {
    return await repository.addGalleryFile(params);
  }
}

class AddGalleryFileParams extends Equatable {
  final List<GalleryFileEntity> galleryFileEntity;
  const AddGalleryFileParams({required this.galleryFileEntity, });

  @override
  List<Object> get props => [galleryFileEntity];
}