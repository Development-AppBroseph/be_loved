import 'dart:convert';
import 'package:be_loved/features/auth/presentation/views/login/phone.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/auth/data/models/auth/user.dart';

class MySharedPrefs {
  final _sharedPreferences = SharedPreferences.getInstance();

  get token async => (await _sharedPreferences).getString('token');

  get user async {
    var user = (await _sharedPreferences).getString('user');
    return user != null && user != ''
        ? UserAnswer.fromJson(jsonDecode(user))
        : null;
  }

  void logOut(BuildContext context) async {
    (await _sharedPreferences).setString('token', '');
    (await _sharedPreferences).setString('user', '');
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
}
