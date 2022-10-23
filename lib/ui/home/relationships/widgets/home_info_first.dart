import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


class HomeInfoFirst extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(top: 11.h, left: 20.w, right: 25.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r), color: Colors.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Вы встречаетесь уже:', style: TextStyle(
                color: Color(0xFF969696),
                fontSize: 15.sp,
                fontWeight: FontWeight.w700
              ),),
              Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: SvgPicture.asset('assets/icons/settings.svg'),
              ),
            ],
          ),
          SizedBox(height: 9.h,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('364', style: TextStyle(
                color: Color(0xFF171717),
                fontSize: 50.sp,
                fontWeight: FontWeight.w700
              ),),
              Padding(
                padding: EdgeInsets.only(bottom: 7.h),
                child: Text('д', style: TextStyle(
                  color: Color(0xFF969696),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700
                ),),
              ),
              SizedBox(width: 10.w,),
              Text('23', style: TextStyle(
                color: Color(0xFF171717),
                fontSize: 50.sp,
                fontWeight: FontWeight.w700
              ),),
              Padding(
                padding: EdgeInsets.only(bottom: 7.h),
                child: Text('ч', style: TextStyle(
                  color: Color(0xFF969696),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700
                ),),
              ),
              SizedBox(width: 10.w,),
              Text('59', style: TextStyle(
                color: Color(0xFF171717),
                fontSize: 50.sp,
                fontWeight: FontWeight.w700
              ),),
              Padding(
                padding: EdgeInsets.only(bottom: 7.h),
                child: Text('мин', style: TextStyle(
                  color: Color(0xFF969696),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700
                ),),
              ),
              
            ],
          )
        ],
      ),
    );
  }
}