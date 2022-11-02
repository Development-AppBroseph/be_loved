import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SwitchBtn extends StatelessWidget {
  final Function(bool val) onChange;
  final bool value;
  const SwitchBtn({required this.onChange, required this.value});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChange(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        alignment: !value ? Alignment.centerLeft : Alignment.centerRight,
        width: 51.w,
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          color: const Color.fromRGBO(120, 120, 128, 0.16)
        ),
        child: Container(
          width: 27.w,
          height: 27.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.r),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.06),
                offset: Offset(0, 3.h),
                blurRadius: 1.w
              ),
              BoxShadow(
                color: const Color.fromRGBO(0, 0, 0, 0.15),
                offset: Offset(0, 3.h),
                blurRadius: 8.w
              ),
            ]
          ),
        ),
      ),
    );
  }
}