


import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/home/domain/entities/archive/memory_entity.dart';

enum AuthenticatedOption {
  unauthenticated, 
  authenticated
}

extension AuthenticatedOptionExtension on AuthenticatedOption {
  String get key {
    switch (this) {
      case AuthenticatedOption.unauthenticated:
        return 'unauthenticated';
      case AuthenticatedOption.authenticated:
        return 'authenticated';
    }
  }
}

class AuthConfig {
  String? token;
  UserAnswer? user;
  AuthenticatedOption? authenticatedOption;
  MemoryEntity? memoryEntity;
  int selectedBackgroundIndex;
  
  AuthConfig({
    this.token, 
    this.user, 
    this.memoryEntity,
    this.selectedBackgroundIndex = 0,
    this.authenticatedOption = AuthenticatedOption.unauthenticated
  });
}
