import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PurposeCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -5.h),
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20.w
          )
        ],
        borderRadius: BorderRadius.circular(20.r)
      ),
      width: 378.w,
      height: 250.h,
      child: CupertinoCard(
        margin: EdgeInsets.zero,
        elevation: 0,
        radius: BorderRadius.circular(40.r),
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/purpose1.png',
                  width: double.infinity,
                  height: 151.h,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 18.h,
                  left: 20.w,
                  child: CupertinoCard(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 8.h),
                    color: Color(0xFFABABAC).withOpacity(0.7),
                    radius: BorderRadius.circular(20.r),
                    child: Text('Осталось 14 дней', style: TextStyles(context).black_15_w800.copyWith(color: ColorStyles.blackColor.withOpacity(0.7)),),
                  ),
                ),
                Positioned(
                  top: 18.h,
                  right: 23.w,
                  child: CupertinoCard(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 11.5.w, vertical: 6.5.h),
                    color: Color(0xFFABABAC).withOpacity(0.7),
                    radius: BorderRadius.circular(20.r),
                    child: Text('+50', style: TextStyles(context).black_15_w800.copyWith(color: ColorStyles.blackColor.withOpacity(0.7)),),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text('Сходите на каток вдвоём', style: TextStyles(context).black_25_w800,),
                    ),
                    SizedBox(width: 4.w,),
                    SizedBox(
                      width: 139.w,
                      height: 42.h,
                      child: CupertinoCard(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        color: ColorStyles.primarySwath,
                        radius: BorderRadius.circular(20.r),
                        child: Center(child: Text('Выполнить', style: TextStyles(context).white_18_w800,)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}