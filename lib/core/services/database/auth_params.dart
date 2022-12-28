


import 'package:be_loved/features/auth/data/models/auth/user.dart';

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
  
  AuthConfig({
    this.token, 
    this.user, 
    this.authenticatedOption = AuthenticatedOption.unauthenticated
  });
}
