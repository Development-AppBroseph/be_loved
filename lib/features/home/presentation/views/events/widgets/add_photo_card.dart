import 'dart:math';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/utils/images.dart';




class AddPhotoCard extends StatelessWidget {
  final Function() onTap;
  final Key? keyAdd;
  final Color? color;
  const AddPhotoCard({this.color, required this.onTap, this.keyAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CupertinoCard(
        padding: EdgeInsets.all(20.w),
        margin: EdgeInsets.zero,
        elevation: 0,
        radius: BorderRadius.circular(40.r),
        color: color ?? Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  SvgImg.camera,
                  height: 23.4.h,
                  width: 26.w,
                  color: ColorStyles.blackColor,
                ),
                SizedBox(width: 19.w,),
                Text('Добавить фото', style: TextStyles(context).black_20_w800,)
              ],
            ),
            Transform.rotate(
                angle: pi / 4,
                child: SvgPicture.asset(
                  SvgImg.add,
                  key: keyAdd,
                  width: 19.w,
                  color: ColorStyles.blackColor,
                )
            )
          ],
        ),
      ),
    );
  }
}