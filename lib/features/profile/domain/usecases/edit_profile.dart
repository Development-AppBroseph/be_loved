import 'dart:io';

import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class EditProfile implements UseCase<User, EditProfileParams> {
  final ProfileRepository repository;
  EditProfile(this.repository);

  @override
  Future<Either<Failure, User>> call(EditProfileParams params) async {
    return await repository.editProfile(params);
  }
}

class EditProfileParams extends Equatable {
  final User user;
  final File? file;
  const EditProfileParams({required this.user, required this.file});

  @override
  List<Object> get props => [user];
}