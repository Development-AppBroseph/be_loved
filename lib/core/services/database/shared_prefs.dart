import 'dart:convert';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/database/secure_storage.dart';
import 'package:be_loved/features/auth/presentation/views/login/phone.dart';
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
    sl<AuthConfig>().user = userAnswer;
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
    (await _sharedPreferences).setString('token', '');
    (await _sharedPreferences).setString('user', '');
    MySecureStorage().setToken('');
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const PhonePage()),
      (route) => false,
    );
  }

  void setUser(String token, UserAnswer user) async {
    (await _sharedPreferences).setString('token', token);
    (await _sharedPreferences).setString(
      'user',
      jsonEncode(user.toJson()),
    );
  }

  void changeName(String newName) async {
    var newUser = (await user) as UserAnswer;
    newUser.me.username = newName;
    setUser(await token, newUser);
  }
}
