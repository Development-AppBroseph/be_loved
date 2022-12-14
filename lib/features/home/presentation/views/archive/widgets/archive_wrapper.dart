import 'dart:async';
import 'dart:math';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/option_black_btn.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';




class ArchiveWrapper extends StatelessWidget {
  final Widget child;
  ArchiveWrapper({required this.child});
  final streamControllerPage = StreamController<int>();

  List<String> data = [
    'Моменты',
    'Галерея',
    'Альбомы',
    'События',
  ];

  @override
  Widget build(BuildContext context) {
    TextStyle style2 = TextStyle(
        color: ColorStyles.blackColor, fontWeight: FontWeight.w800, fontSize: 18.sp);

    TextStyle style3 = TextStyle(
        color: ColorStyles.greyColor, fontWeight: FontWeight.w800, fontSize: 18.sp);
        
    return Container(
      color: ColorStyles.backgroundColorGrey,
      child: StreamBuilder<int>(
        stream: streamControllerPage.stream,
        initialData: 1,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 25.w,
                    right: 25.w,
                    top: 45.h+MediaQuery.of(context).padding.top,
                    bottom: 22.h
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){},
                        child: SizedBox(
                          height: 38.h,
                          child: CupertinoCard(
                            margin: EdgeInsets.zero,
                            elevation: 0,
                            color: ColorStyles.blackColor,
                            radius: BorderRadius.circular(20.r),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: CupertinoCard(
                                    elevation: 0,
                                    margin: EdgeInsets.all(2.w),
                                    radius: BorderRadius.circular(16.r),
                                    color: ColorStyles.backgroundColorGrey
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                                  child: Center(
                                    child: Text(
                                      '10/10 ГБ', 
                                      style: TextStyles(context).white_18_w800.copyWith(
                                        color: ColorStyles.blackColor
                                      )
                                    )
                                  ),
                                ),



                                
                              ],
                            ),
                          ),
                        ),
                      ),


                      _buildAddBtn(
                        context,
                        (){}
                      )
                    ],
                  )
                ),

                SizedBox(
                  height: 38.w,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 15.w, left: index == 0 ? 25.w : 0),
                        height: 38.h,
                        child: CupertinoCard(
                          margin: EdgeInsets.zero,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          color: index == snapshot.data 
                          ? ColorStyles.blackColor
                          : Colors.white,
                          radius: BorderRadius.circular(20.r),
                          child: Center(
                            child: Text(
                              data[index], 
                              style: TextStyles(context).white_18_w800.copyWith(
                                color: index == snapshot.data 
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
                SizedBox(height: 30.h,),
                
                child
              ],
            ),
          );
        }),
    );
  }




  Widget _buildAddBtn(BuildContext context, Function() onTap){
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 38.h,
        width: 65.w,
        child: CupertinoCard(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: ColorStyles.primarySwath,
          radius: BorderRadius.circular(20.r),
          child: Center(
            child: Transform.rotate(
                        angle: pi / 4,
                        child:
                            SvgPicture.asset(SvgImg.add, height: 16.h, color: Colors.white,))
          ),
        ),
      ),
    );
  }
}