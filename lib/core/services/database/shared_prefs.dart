import 'dart:convert';

import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/database/secure_storage.dart';
import 'package:be_loved/features/auth/presentation/views/login/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/auth/data/models/auth/user.dart';
import '../../../locator.dart';

class MySharedPrefs {
  final _sharedPreferences = SharedPreferences.getInstance();

  final nameRelationShips = 'nameRelationShips';

  get token async => (await _sharedPreferences).getString('token');

  get user async {
    var user = (await _sharedPreferences).getString('user');
    UserAnswer? userAnswer = user != null && user != ''
        ? UserAnswer.fromJson(jsonDecode(user))
        : null;
    // sl<AuthConfig>().user = userAnswer;
    sl<AuthConfig>().token = await MySecureStorage().getToken();
    return userAnswer;
  }

  void setNameRelationShips(String value) async {
    (await _sharedPreferences).setString(nameRelationShips, value);
  }

  get getNameRelationShips async {
    return (await _sharedPreferences).getString(nameRelationShips);
  }

  void logOut(BuildContext context) async {
    (await _sharedPreferences).setString('toke`n', '');
    (await _sharedPreferences).setString('user', '');
    MySecureStorage().setToken('');
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
      (route) => false,
    );
  }

  Future<void> setUser(String token, UserAnswer user) async {
    (await _sharedPreferences).setString('token', token);
    (await _sharedPreferences).setString(
      'user',
      jsonEncode(user.toJson()),
    );
  }

  Future<void> updateUser(UserAnswer user) async {
    (await _sharedPreferences).setString(
      'user',
      jsonEncode(user.toJson()),
    );
  }

  Future<void> setBoolYears(bool isShwon) async {
    (await _sharedPreferences).setBool('year', isShwon);
  }

  Future<void> deleteBoolYears() async {
    (await _sharedPreferences).remove('year');
  }

  Future<bool?> getBoolYears() async {
    return (await _sharedPreferences).getBool('year');
  }

  Future<int?> get year async => (await _sharedPreferences).getInt('year');

  void changeName(String newName) async {
    var newUser = (await user) as UserAnswer;
    newUser.me.username = newName;
    setUser(await token, newUser);
  }
}
