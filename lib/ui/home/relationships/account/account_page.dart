import 'dart:async';
import 'dart:math';
import 'package:be_loved/core/helpers/constants.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccountPage extends StatefulWidget {
  final VoidCallback prevPage;
  const AccountPage({Key? key, required this.prevPage}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _streamController = StreamController<int>();
  final _streamControllerCarousel = StreamController<double>();

  @override
  void dispose() {
    super.dispose();
    _streamController.close();
    _streamControllerCarousel.close();
  }

  @override
  Widget build(BuildContext context) {
    LinearGradient gradientText = const LinearGradient(
      colors: [
        Color.fromRGBO(255, 255, 255, 1),
        Color.fromRGBO(255, 255, 255, 0),
      ],
      transform: GradientRotation(pi / 2),
    );
    return Material(
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Image.asset('assets/images/beloved_background.png')
                    // Container(
                    //   decoration: const BoxDecoration(
                    //     gradient: LinearGradient(
                    //       colors: [
                    //         Color.fromRGBO(51, 0, 27, 1),
                    //         Color.fromRGBO(242, 37, 160, 1),
                    //       ],
                    //       transform: GradientRotation(pi / 4),
                    //     ),
                    //   ),
                    // ),
                    // ListView.builder(
                    //     itemCount: 4,
                    //     itemBuilder: ((context, index) {
                    //       return Container(
                    //         height: 101.h,
                    //         width: 429.w,
                    //         decoration: BoxDecoration(
                    //           gradient: gradientText,
                    //         ),
                    //         child: SvgPicture.asset(
                    //             'assets/icons/beloved_text.svg'),
                    //       );
                    //     })),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Container(
                    //       height: 101.h,
                    //       width: 429.w,
                    //       decoration: BoxDecoration(
                    //         gradient: gradientText,
                    //       ),
                    //       child:
                    //           SvgPicture.asset('assets/icons/beloved_text.svg'),
                    //     ),
                    //     Container(
                    //       height: 101.h,
                    //       width: 429.w,
                    //       decoration: BoxDecoration(
                    //         gradient: gradientText,
                    //       ),
                    //       child:
                    //           SvgPicture.asset('assets/icons/beloved_text.svg'),
                    //     ),
                    //     Container(
                    //       height: 101.h,
                    //       width: 429.w,
                    //       decoration: BoxDecoration(
                    //         gradient: gradientText,
                    //       ),
                    //       child:
                    //           SvgPicture.asset('assets/icons/beloved_text.svg'),
                    //     ),
                    //     Container(
                    //       height: 101.h,
                    //       width: 429.w,
                    //       decoration: BoxDecoration(
                    //         gradient: gradientText,
                    //       ),
                    //       child:
                    //           SvgPicture.asset('assets/icons/beloved_text.svg'),
                    //     )
                    //   ],
                    // ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.black.withOpacity(0.3),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Expanded(child: Container(color: backgroundColorGrey))
            ],
          ),
          content(),
        ],
      ),
    );
  }

  Widget content() {
    TextStyle style1 = TextStyle(
        fontWeight: FontWeight.w700, color: Colors.white, fontSize: 15.sp);
    TextStyle style2 = TextStyle(
        fontWeight: FontWeight.w700, color: Colors.white, fontSize: 30.sp);
    TextStyle style3 = TextStyle(
        fontWeight: FontWeight.w800, color: Colors.white, fontSize: 18.sp);

    return StreamBuilder<int>(
        stream: _streamController.stream,
        initialData: 0,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15.w, top: 76.h),
                  child: GestureDetector(
                    onTap: widget.prevPage,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 55.h,
                          width: 55.w,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/back.svg',
                                color: Colors.white,
                                width: 15.w,
                                height: 26.32,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Назад',
                          style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 186.h),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 135.h),
                            child: Container(
                              height: 120.h,
                              width: 428.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: 105.w,
                                      right: 105.w,
                                      top: 38.h,
                                      bottom: 25.h,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('Никита ',
                                                style: style3.copyWith(
                                                    fontSize: 30.sp,
                                                    color: Colors.black,
                                                    height: 0.9)),
                                            Text(' Белых',
                                                style: style3.copyWith(
                                                    fontSize: 30.sp,
                                                    color: Colors.black,
                                                    height: 0.9)),
                                          ],
                                        ),
                                        SizedBox(height: 5.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('+7 *** *** 00-00',
                                                style: style3.copyWith(
                                                    fontSize: 15.sp,
                                                    color: Colors.black,
                                                    height: 1)),
                                            SvgPicture.asset(
                                                'assets/icons/vk_logo.svg')
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          photo(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.h),
                        child: Container(
                          height: 120.h,
                          width: 428.w,
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Страница VK',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SvgPicture.asset('assets/icons/vk_logo.svg')
                                ],
                              ),
                              SizedBox(height: 15.h),
                              Row(
                                children: [
                                  Container(
                                    height: 60.h,
                                    width: 60.h,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 18.w),
                                    decoration: BoxDecoration(
                                      color: greyColor,
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/camera.svg',
                                    ),
                                  ),
                                  SizedBox(width: 28.w),
                                  Text(
                                    'Никита Белых',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    height: 45.h,
                                    width: 45.w,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          height: 5.57.h,
                                          width: 27.86,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: 3,
                                            itemBuilder:
                                                (BuildContext context, index) {
                                              return Container(
                                                margin: EdgeInsets.only(
                                                    left: index == 0
                                                        ? 0
                                                        : 5.57.w),
                                                height: 5.57.sp,
                                                width: 5.57.sp,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1.5),
                                                  color: Colors.black,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.h),
                        child: Container(
                          height: 250.h,
                          width: 428.w,
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 21.h, bottom: 50.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Основные',
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 32.h),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 45.h,
                                      width: 45.w,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/data.svg',
                                            height: 34.h,
                                            width: 34.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 21.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Данные',
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          'Редактировать',
                                          style: TextStyle(
                                            color: greyColor,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      height: 45.h,
                                      width: 45.w,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Transform.rotate(
                                            angle: pi,
                                            child: SvgPicture.asset(
                                              'assets/icons/back.svg',
                                              height: 19.96.h,
                                              width: 11.37.w,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 45.h,
                                      width: 45.w,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/update.svg',
                                            height: 34.h,
                                            width: 34.w,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 21.w),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Сменить пароль',
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          'Управлениие',
                                          style: TextStyle(
                                            color: greyColor,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      height: 45.h,
                                      width: 45.w,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Transform.rotate(
                                            angle: pi,
                                            child: SvgPicture.asset(
                                              'assets/icons/back.svg',
                                              height: 19.96.h,
                                              width: 11.37.w,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget photo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 165.h,
          height: 165.h,
          child: GestureDetector(
            child: Material(
              color: Colors.white,
              shape: SquircleBorder(
                radius: BorderRadius.all(
                  Radius.circular(80.r),
                ),
              ),
              clipBehavior: Clip.hardEdge,
            ),
          ),
        ),
        SizedBox(
          width: 157.h,
          height: 157.h,
          child: GestureDetector(
            child: Material(
              color: const Color.fromRGBO(150, 150, 150, 1),
              shape: SquircleBorder(
                radius: BorderRadius.all(
                  Radius.circular(80.r),
                ),
              ),
              clipBehavior: Clip.hardEdge,
              child: Padding(
                padding: EdgeInsets.all(50.h),
                child: SvgPicture.asset(
                  'assets/icons/camera.svg',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
