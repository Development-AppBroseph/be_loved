import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MySecureStorage {
  final storage = const FlutterSecureStorage();

  Future<String?> getToken() => storage.read(key: 'token');

  void setToken(String token) => storage.write(key: 'token', value: token);
}
