import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';

class StandartSnackBar {
  static void show(String text, SnackBarStatus status) {
    showOverlayNotification(
      (context) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            width: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              // boxShadow: shadow,
            ),
            child: Material(
              color: Colors.transparent,
              child: Row(
                children: [
                  Icon(
                    status.icon,
                    color: status.color,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SelectableText(
                      text,
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        color: const Color.fromRGBO(137, 137, 137, 1.0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      duration: const Duration(milliseconds: 4000),
    );
  }
}

class SnackBarStatus {
  SnackBarStatus(
    this.icon,
    this.color,
  );

  final IconData icon;
  final Color color;

  static SnackBarStatus success() {
    return SnackBarStatus(
      Icons.done,
      Colors.white,
    );
  }

  static SnackBarStatus warning() {
    return SnackBarStatus(
      Icons.error,
      Colors.white,
    );
  }

  static SnackBarStatus message() {
    return SnackBarStatus(
      Icons.sms_rounded,
      Colors.yellow.shade800,
    );
  }

  static SnackBarStatus internetResultSuccess() {
    return SnackBarStatus(
      Icons.check_circle,
      Colors.white,
    );
  }

  static SnackBarStatus loading() {
    return SnackBarStatus(
      Icons.info,
      Colors.white,
    );
  }
}
