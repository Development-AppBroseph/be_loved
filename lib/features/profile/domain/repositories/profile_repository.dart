import 'package:be_loved/core/error/failures.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/home/domain/entities/statics/statics_entity.dart';
import 'package:be_loved/features/profile/domain/entities/back_entity.dart';
import 'package:be_loved/features/profile/domain/usecases/connect_vk.dart';
import 'package:be_loved/features/profile/domain/usecases/edit_backgrounds_info.dart';
import 'package:be_loved/features/profile/domain/usecases/edit_profile.dart';
import 'package:be_loved/features/profile/domain/usecases/edit_relation.dart';
import 'package:be_loved/features/profile/domain/usecases/send_files_to_mail.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<Failure, User>> editProfile(EditProfileParams params);
  Future<Either<Failure, String>> editRelation(EditRelationParams params);
  Future<Either<Failure, StaticsEntity>> getStats();
  Future<Either<Failure, String>> connectVK(ConnectVKParams params);
  Future<Either<Failure, void>> sendFilesToMail(SendFilesToMailParams params);
  Future<Either<Failure, BackEntity>> getBackgroundsInfo();
  Future<Either<Failure, void>> editBackgroundsInfo(EditBackgroundsInfoParams params);
}