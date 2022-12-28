import 'dart:ui';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/purpose_card.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PurposesPage extends StatelessWidget {

  List<String> data = [
    'Обменять опыт',
    'Все',
    'Выполняются',
    'Доступные',
    'История'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/purpose1.png',
                width: double.infinity,
                height: 416.h+MediaQuery.of(context).padding.top,
                fit: BoxFit.cover,
              ),
              ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: SizedBox(
                    width: double.infinity,
                    height: 416.h+MediaQuery.of(context).padding.top,
                  ),
                ),
              ),
              Positioned.fill(
                top: 76.h+MediaQuery.of(context).padding.top,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Сезонная цель', style: TextStyles(context).white_35_w800,),
                    SizedBox(height: 23.h,),
                    PurposeCard()
                  ],
                )
              )
            ],
          ),

          //Content
          //List horizontal
          SizedBox(
            height: 18.h,
          ),
          SizedBox(
            height: 37.w,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 15.w, left: index == 0 ? 15.w : 0),
                  height: 37.h,
                  child: CupertinoCard(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    color: index == 0
                    ? ColorStyles.redColor
                    : data[index] == 'Выполняются' 
                    ? ColorStyles.primarySwath 
                    : Colors.white,
                    radius: BorderRadius.circular(20.r),
                    child: Center(
                      child: Text(
                        data[index], 
                        style: TextStyles(context).white_18_w800.copyWith(
                          color: index == 0 || data[index] == 'Выполняются' 
                          ? Colors.white
                          : ColorStyles.greyColor
                        )
                      )
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 39.h,
          ),

          //Purposes
          Container(
            margin: EdgeInsets.only(bottom: 15.h),
            child: PurposeCard(),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15.h),
            child: PurposeCard(),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15.h),
            child: PurposeCard(),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15.h),
            child: PurposeCard(),
          )
        ],
      ),
    );
  }
}
