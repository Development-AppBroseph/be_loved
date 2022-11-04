import 'dart:async';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ArchivePage extends StatefulWidget {
  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  final streamControllerPage = StreamController<int>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: ColorStyles.backgroundColorGrey),
        content(),
      ],
    );
  }

  @override
  void dispose() {
    streamControllerPage.close();
    super.dispose();
  }

  Widget content() {
    TextStyle style2 = TextStyle(
        color: ColorStyles.redColor, fontWeight: FontWeight.w700, fontSize: 15.sp);

    TextStyle style3 = TextStyle(
        color: ColorStyles.greyColor, fontWeight: FontWeight.w700, fontSize: 15.sp);

    TextStyle style4 = TextStyle(fontWeight: FontWeight.w700, fontSize: 25.sp);

    return Stack(
      children: [
        StreamBuilder<int>(
            stream: streamControllerPage.stream,
            initialData: 0,
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 38.h, left: 25.w, right: 25.w),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 5.57.sp,
                            width: 33.43,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (BuildContext context, index) {
                                return Container(
                                  margin: EdgeInsets.only(right: 5.57.sp),
                                  height: 5.57.sp,
                                  width: 5.57.sp,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1.5),
                                    color: ColorStyles.greyColor,
                                  ),
                                );
                              },
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 45.w,
                            height: 45.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(SvgImg.addNewEvent),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 11.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 82.w),
                      child: Column(
                        children: [
                          Text('Общий архив', style: style4),
                          SizedBox(height: 9.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () => streamControllerPage.add(0),
                                child: Text('Главная',
                                    style:
                                        snapshot.data! == 0 ? style2 : style3),
                              ),
                              GestureDetector(
                                onTap: () => streamControllerPage.add(1),
                                child: Text('События',
                                    style:
                                        snapshot.data! == 1 ? style2 : style3),
                              ),
                              GestureDetector(
                                onTap: () => streamControllerPage.add(2),
                                child: Text('Моменты',
                                    style:
                                        snapshot.data! == 2 ? style2 : style3),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 38.h),
                    ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          if (index % 5 == 0) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 4.h),
                              child: Container(
                                height: 284.h,
                                color: ColorStyles.greyColor2,
                              ),
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 4.h),
                              child: Row(
                                children: [
                                  Container(
                                    height: 140.h,
                                    width: 140.w,
                                    color: ColorStyles.greyColor2,
                                  ),
                                  SizedBox(width: 4.w),
                                  Container(
                                    height: 140.h,
                                    width: 140.w,
                                    color: ColorStyles.greyColor2,
                                  ),
                                  SizedBox(width: 4.w),
                                  Container(
                                    height: 140.h,
                                    width: 140.w,
                                    color: ColorStyles.greyColor2,
                                  ),
                                ],
                              ),
                            );
                          }
                        }),
                        itemCount: 20),
                    SizedBox(height: 117.h),
                  ],
                ),
              );
            }),
        Padding(
          padding: EdgeInsets.only(bottom: 161.h),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 40.h,
              margin: EdgeInsets.symmetric(horizontal: 45.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Дни', style: style3),
                  Text('Месяца', style: style3),
                  Text('Годы', style: style3),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
