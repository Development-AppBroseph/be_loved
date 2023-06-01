import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/colors/color_styles.dart';
import '../../utils/images.dart';

class NumberAlert extends StatefulWidget {
  const NumberAlert({Key? key}) : super(key: key);

  @override
  State<NumberAlert> createState() => _NumberAlertState();
}

class _NumberAlertState extends State<NumberAlert> {
  late Timer _timer;
  int _start = 5;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
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
              children:  [
                Text(
                  'Номер успешно изменен',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color(0xff20CB83),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                  textAlign: TextAlign.start,
                ),
                Text(
                  'Следующий вход в аккаунт будет\nпроизводиться по новому номеру',
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
                  color: const Color(0xff20CB83),
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
