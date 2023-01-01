import 'dart:ui';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';



class SelectedCheck extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 30.w,
      bottom: 30.h,
      child: SizedBox(
        width: 38.h,
        height: 38.h,
        child: ClipPath.shape(
          shape: SquircleBorder(
              radius: BorderRadius.circular(26.r)),
          child: BackdropFilter(
            filter:
                ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.white.withOpacity(0.7),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                SvgImg.check2,
                color: ColorStyles.blackColor.withOpacity(0.7),
                width: 25.12.h,
              )
            ),
          ),
        ),
      ),
    );
  }
}