import 'dart:async';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthAlert extends StatefulWidget {
  const AuthAlert({Key? key}) : super(key: key);

  @override
  State<AuthAlert> createState() => _AuthAlertState();
}

class _AuthAlertState extends State<AuthAlert> {
  late Timer timer;
  int _start = 5;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      margin: const EdgeInsets.only(
        right: 25,
        left: 25,
        bottom: 111,
      ),
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: ColorStyles.white.withOpacity(0.9),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            SvgImg.alertVpn,
            color: ColorStyles.redColor,
          ),
          const SizedBox(
            width: 10,
          ),
          Flexible(
            flex: 40,
            fit: FlexFit.tight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Приглашение не отправлено',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: ColorStyles.redColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.start,
                ),
                Text(
                  'Партнёр должен скачать приложение\nи зайти на этот экран',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 18.h,
                width: 18.w,
                decoration: BoxDecoration(
                  color: ColorStyles.redColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                child: Text(
                  _start.toString(),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
