import 'package:be_loved/core/network.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppData extends ChangeNotifier {
  AppData(
      this._token,
      );

  static final _prefs = SharedPreferences.getInstance();
  static const _prefsJWT = "_prefsJWT";
  final net = NetHandler();


  late int _codeNumber;
   int get codeNumber => _codeNumber;

  late String _phoneNumber;
  String get phoneNumber => _phoneNumber;

  bool? _isNickNameBusy;
  bool? get isNickNameBusy => _isNickNameBusy;

  String? _userToken;
  String? get userToken => _userToken;


  String _token;
  String get token => _token;

  static Future<AppData> getInstance() async {
    return AppData((await getUserToken()));
  }

  void getRegCode(String number) async {
    _codeNumber = (await net.registration(number))!;
    notifyListeners();
  }

  void saveNumber(String number) async {
    _phoneNumber = number;
    notifyListeners();
  }

  void checkNickName(String name) async {
    _isNickNameBusy = await net.checkNickName(name);
    notifyListeners();
  }

  void checkIsUserExist(String number, String code) async {
    _userToken = await net.checkIsUserExist(number, code);
    notifyListeners();
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
