


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
  // UserEntity? userEntity;
  AuthenticatedOption? authenticatedOption;
  
  AuthConfig({
    this.token, 
    // this.userEntity, 
    this.authenticatedOption = AuthenticatedOption.unauthenticated
  });
}
