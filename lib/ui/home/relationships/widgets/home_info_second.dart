import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';


class HomeInfoSecond extends StatelessWidget {
  final double data;
  HomeInfoSecond({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.only(top: 10.h, left: 20.w, right: 30.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r), color: Colors.white),
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
              Text('16 марта', style: TextStyle(
                color: Color(0xFF171717),
                fontSize: 35.sp,
                fontWeight: FontWeight.w700
              ),),
              SizedBox(width: 10.w,),
              Text('2022', style: TextStyle(
                color: Color(0xFF171717),
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
                  SvgPicture.asset('assets/icons/home_stats.svg'),
                  SizedBox(width: 26.w,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Статистика', style: TextStyle(
                        color: Color(0xFF171717),
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
                child: SvgPicture.asset('assets/icons/home_arrow.svg'),
              )
            ],
          ),
          SizedBox(height: 20.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icons/home_logo.svg'),
                  SizedBox(width: 26.w,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Отношения', style: TextStyle(
                        color: Color(0xFF171717),
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
                child: SvgPicture.asset('assets/icons/home_arrow.svg'),
              )
            ],
          ),
          
        ],
      ),
    );
  }
}