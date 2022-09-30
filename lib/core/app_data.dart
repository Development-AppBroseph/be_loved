import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppData extends ChangeNotifier {
  AppData(
      this._token,
      );

  static final _prefs = SharedPreferences.getInstance();
  static const _prefsJWT = "_prefsJWT";

  String _token;
  String get token => _token;

  static Future<AppData> getInstance() async {
    return AppData((await getUserToken()));
  }

  static Future<String> getUserToken() async {
    return (await _prefs).getString(_prefsJWT) ?? "";
  }

  void setUserToken(String value) async {
    _token = value;
    notifyListeners();
    (await _prefs).setString(_prefsJWT, value);
  }
}
