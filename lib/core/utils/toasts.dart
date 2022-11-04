import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/colors/color_styles.dart';

void showAlertToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.TOP,
      backgroundColor: ColorStyles.blackColor,
      textColor: Colors.white,
      timeInSecForIosWeb: 1,
      toastLength: Toast.LENGTH_LONG,
      fontSize: 16,);
}

void showSuccessAlertToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      timeInSecForIosWeb: 1,
      gravity: ToastGravity.TOP,
      backgroundColor: ColorStyles.accentColor,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      fontSize: 20,);
}