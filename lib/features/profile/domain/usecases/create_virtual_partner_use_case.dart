import 'dart:io';

import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/profile/domain/repositories/profile_repository.dart';

class CreateVirtualPartnerUseCase {
  final ProfileRepository repository;

  CreateVirtualPartnerUseCase({required this.repository});
  Future<UserAnswer> createVirtualCall(String name, File? photo) async {
    return await repository.createVirtualPartner(name, photo);
  }

  Future<UserAnswer> editVirtualCall(String name, File? photo) async {
    return await repository.editVirtualPartner(name, photo);
  }
}
