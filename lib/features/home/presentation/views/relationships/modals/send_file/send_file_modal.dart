import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'send_file_widget.dart';

 showModalSendFile(BuildContext context, {bool isParting = false}) async {
  return await showMaterialModalBottomSheet(
      animationCurve: Curves.easeInOutQuint,
      elevation: 12,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.2),
      duration: const Duration(milliseconds: 600),
      backgroundColor: Colors.transparent,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(
      //     top: Radius.circular(50.r),
      //   ),
      // ),
      context: context,
      builder: (context) {
        return SendFilesWidget(isParting: isParting,);
      });
}
