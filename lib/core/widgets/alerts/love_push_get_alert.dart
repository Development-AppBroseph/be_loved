import 'dart:async';

import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/colors/color_styles.dart';
import '../../utils/images.dart';

class LovePushGetAlert extends StatefulWidget {
  const LovePushGetAlert({Key? key}) : super(key: key);

  @override
  State<LovePushGetAlert> createState() => _LovePushGetAlertState();
}

class _LovePushGetAlertState extends State<LovePushGetAlert> {
  final Shader linearGradient = const LinearGradient(
    colors: [
      Color(0xff0177FF),
      Color(0xffFF3347),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 360.0, 70.0));
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
      height: 78.h,
      margin: const EdgeInsets.only(right: 25, left: 25, bottom: 111,),
       padding: const EdgeInsets.only(top: 0, bottom: 0, left: 26, right: 20),  
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: ColorStyles.white.withOpacity(0.9),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Img.gredientHeart,
            height: 31,
            width: 36,
          ),
          const SizedBox(
            width: 18,
          ),
          Flexible(
            flex: 40,
            fit: FlexFit.tight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Text(
                  '${sl<AuthConfig>().user!.love!.username} любит тебя',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                    foreground: Paint()..shader = linearGradient,
                  ),
                  textAlign: TextAlign.start,
                ),
                const Text(
                  'Партнёр отправил уведомление о том, как сильно тебя любит',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
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
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff0177FF),
                      Color(0xffFF3347),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                margin: const EdgeInsets.only(bottom: 15),
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