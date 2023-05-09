import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class OptionBtn extends StatelessWidget {
  final Function() onTap;
  final String text;
  final bool isPhone;
  OptionBtn({
    required this.onTap,
    required this.text,
    required this.isPhone,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 378.w,
        height: 60.h,
        child: CupertinoCard(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: isPhone ? ColorStyles.white : const Color(0xFF0077FF),
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          radius: BorderRadius.circular(20.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                isPhone ? SvgImg.phone : SvgImg.vk,
                color: ColorStyles.blackColor,
                height: isPhone ? 22.h : 18.h,
              ),
              Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: ColorStyles.blackColor,
                ),
              ),
              SizedBox(
                width: isPhone ? 22.w : 28.85.w,
              )
            ],
          ),
        ),
      ),
    );
  }
}
