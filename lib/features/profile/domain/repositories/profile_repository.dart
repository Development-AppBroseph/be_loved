import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/home/domain/entities/statics/statics_entity.dart';
import 'package:be_loved/features/profile/domain/usecases/edit_profile.dart';
import 'package:be_loved/features/profile/domain/usecases/edit_relation.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> editProfile(EditProfileParams params);
  Future<Either<Failure, String>> editRelation(EditRelationParams params);
  Future<Either<Failure, StaticsEntity>> getStats();
}