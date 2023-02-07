import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviewIndicator extends StatelessWidget {
  final int currentIndex;
  PreviewIndicator({required this.currentIndex});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28.w,
      height: 5.6.h,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
              3,
              (index) => Container(
                    height: 5.6.h,
                    width: 5.6.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.r),
                        color: index == currentIndex
                            ? ColorStyles.white
                            : ColorStyles.greyColor),
                  ))),
    );
  }
}
