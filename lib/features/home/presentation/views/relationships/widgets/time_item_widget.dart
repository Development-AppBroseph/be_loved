import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TimeItemWidget extends StatelessWidget {
  final String text;
  TimeItemWidget({required this.text});
  
  TextStyle style3 = TextStyle(
    color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
    fontSize: 15.sp,
    fontWeight: FontWeight.w700
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorStyles.greyColor3,
        borderRadius: BorderRadius.circular(7.r)
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.5.h),
      child: Text(text, style: style3,),
    );
  }
}