import 'dart:io';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'avatar_modal_widget.dart';

showModalAvatarChange(BuildContext context, Function(File? file) onTap) {
  showMaterialModalBottomSheet(
    animationCurve: Curves.easeInOutQuint,
      elevation: 12,
      barrierColor: Color.fromRGBO(0, 0, 0, 0.2),
      duration: Duration(milliseconds: 600),
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return AvatarModalWidget(onTap: onTap);
      });
}

