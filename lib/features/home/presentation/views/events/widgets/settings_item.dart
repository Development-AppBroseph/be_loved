import 'dart:ui';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';




class SettingsItem extends StatelessWidget {
  final Function() onTap;
  final String text;
  final String icon;
  final BorderRadius? borderRadius;
  final Color? color;
  final Size? iconSize;
  final double? opacity;
  SettingsItem({required this.icon, this.opacity, this.iconSize, this.borderRadius, this.color, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        decoration: BoxDecoration(
          // borderRadius:  borderRadius 
          // ?? BorderRadius.only(
          //   topLeft: Radius.circular(17.r),
          //   topRight: Radius.circular(17.r),
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20.w,
              offset: Offset(0, 5.h)
            )
          ]
        ),
        child: ClipPath.shape(
          shape: SquircleBorder(
            radius:  borderRadius 
              ?? BorderRadius.only(
                topLeft: Radius.circular(34.r),
                topRight: Radius.circular(34.r),
              ),
          ),
          child: SizedBox(
            width: 241.w,
            height: 50.h,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.white.withOpacity(opacity ?? 0.9),
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Opacity(
                    opacity: opacity ?? 1,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(text, style: TextStyles(context).black_15_w700.copyWith(color: color ?? ColorStyles.blackColor),),
                        Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: SvgPicture.asset(
                            icon,
                            height: iconSize != null ? iconSize!.height : 14.5.h,
                            width: iconSize != null ? iconSize!.width : 14.5.w,
                            color: color ?? ColorStyles.blackColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}