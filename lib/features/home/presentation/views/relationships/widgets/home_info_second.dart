import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';


class HomeInfoSecond extends StatelessWidget {
  final double data;
  final Function() onRelationTap;
  HomeInfoSecond({required this.data, required this.onRelationTap});

  @override
  Widget build(BuildContext context) {
    DateTime date = sl<AuthConfig>().user == null || sl<AuthConfig>().user!.date == null
    ? DateTime.now() 
    : DateFormat("yyyy-MM-dd").parse(sl<AuthConfig>().user!.date!, true).toLocal();
    return Container(
      width: double.infinity,
      height: double.infinity,
      // padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 30.w),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(20.r), color: Colors.white),
      child: CupertinoCard(
        radius: BorderRadius.circular(40.r),
        color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
        elevation: 0,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 30.w),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Text('Вы начали встречаться:', style: TextStyle(
              color: Color(0xFF969696),
              fontSize: 15.sp,
              fontWeight: FontWeight.w700
            ),),
            SizedBox(height: 9.h,),
            Row(
              children: [
                Text(DateFormat('dd MMMM', 'RU').format(date), style: TextStyle(
                  color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                  fontSize: 35.sp,
                  fontWeight: FontWeight.w700
                ),),
                SizedBox(width: 10.w,),
                Text(DateFormat('yyyy', 'RU').format(date), style: TextStyle(
                  color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                  fontSize: 35.sp,
                  fontWeight: FontWeight.w700
                ),),
              ],
            ),
            SizedBox(
              height: (30.h - data * 22.h),
            ),
            Container(
              width: double.infinity,
              height: 1.h,
              color: Color(0xFF969696),
            ),
            SizedBox(height: 24.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(SvgImg.homeStats, height: 34.h,),
                    SizedBox(width: 26.w,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Статистика', style: TextStyle(
                          color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700
                        ),),
                        SizedBox(height: 2.h,),
                        Text('Посмотреть', style: TextStyle(
                          color: Color(0xFF969696),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500
                        ),),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right: 17.w),
                  child: SvgPicture.asset(SvgImg.homeArrow, height: 20.h, color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],),
                )
              ],
            ),
            SizedBox(height: 20.h,),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: onRelationTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(SvgImg.homeLogo, height: 34.h,),
                      SizedBox(width: 26.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Отношения', style: TextStyle(
                            color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700
                          ),),
                          SizedBox(height: 2.h,),
                          Text('Настроить', style: TextStyle(
                            color: Color(0xFF969696),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500
                          ),),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 17.w),
                    child: SvgPicture.asset(SvgImg.homeArrow, height: 20.h, color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],),
                  )
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}