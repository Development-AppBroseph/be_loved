import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class TodayTextWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Text(
      'Сегодня:',
      style: TextStyle(
        color: ColorStyles.redColor,
        fontSize: 25.sp,
        fontWeight: FontWeight.w800,
        height: 1,
      ),
    );
  }
}