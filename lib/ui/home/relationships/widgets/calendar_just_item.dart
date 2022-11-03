import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/constants.dart';




class CalendarJustItem extends StatelessWidget {
  final String text;
  final bool disabled;
  CalendarJustItem({required this.text, required this.disabled});
  
  TextStyle style2 = TextStyle(
    color: blackColor,
    fontSize: 18.sp,
    fontWeight: FontWeight.w700
  );
  @override
  Widget build(BuildContext context) {
    return Container(  
      width: 40.h,
      height: 40.h,
      alignment: Alignment.center,  
      child: Text(  
        text,  
        style: style2.copyWith(color: disabled ? greyColor : blackColor),  
      )
    );
  }
}