import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class CalendarJustItem extends StatelessWidget {
  final String text;
  final bool disabled;
  CalendarJustItem({required this.text, required this.disabled});
  @override
  Widget build(BuildContext context) {
    return Container(  
      width: 40.h,
      height: 40.h,
      alignment: Alignment.center,  
      child: Text(  
        text,  
        style: TextStyles(context).black_18_w700.copyWith(color: disabled ? ColorStyles.greyColor : ColorStyles.blackColor),  
      )
    );
  }
}