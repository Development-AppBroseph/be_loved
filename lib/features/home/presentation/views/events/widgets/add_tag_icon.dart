import 'dart:math';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';



class AddTagIcon extends StatelessWidget {
  final Function() onTap;
  final Key? key;
  final double? width;
  AddTagIcon({required this.onTap, this.key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: CupertinoCard(
        color: ColorStyles.greyColor,
        elevation: 0,
        margin: EdgeInsets.zero,
        radius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
              Positioned.fill(
                child: CupertinoCard(
                  elevation: 0,
                  margin: EdgeInsets.all(1.w),
                  radius: BorderRadius.circular(17.r),
                  color: ColorStyles.backgroundColorGrey,
                ),
              ),
            Container(
              height: 38.h,
              width: width ?? 80.w,
              child: Center(
                  child: Transform.rotate(
                        angle: pi / 4,
                        child:
                            SvgPicture.asset(SvgImg.add, height: 14.h,))
                )
            ),
          ],
        ),
      ),
    );
  }
}