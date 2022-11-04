import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CalendarSelectedItem extends StatelessWidget {
  final String text;
  CalendarSelectedItem({required this.text});
  
  TextStyle style2 = TextStyle(
    color: ColorStyles.blackColor,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700
  );
  @override
  Widget build(BuildContext context) {
    return Container(  
      width: 40.h,
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.h),
        border: Border.all(
          color: ColorStyles.redColor,
          width: 5.h
        )
      ),
      alignment: Alignment.center,  
      child: Text(  
        text,  
        style: style2.copyWith(color: ColorStyles.redColor),  
      )
    );
  }
}