import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomSheetGreyLine extends StatelessWidget {
  const BottomSheetGreyLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.h,
      width: 100.w,
      margin: EdgeInsets.only(top: 7.h, bottom: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: const Color(0xff969696)),
    );
  }
}
