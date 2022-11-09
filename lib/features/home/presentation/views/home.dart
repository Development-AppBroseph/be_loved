import 'dart:async';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/presentation/views/archive/archive.dart';
import 'package:be_loved/features/home/presentation/views/events/events_page.dart';
import 'package:be_loved/features/home/presentation/views/purposes/purposes_page.dart';
import 'package:be_loved/features/home/presentation/views/relationships/main_relation_ships_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/colors/color_styles.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageController = PageController();

  final streamController = StreamController();

  int currentIndex = 0;

  List<Widget> pages = [
    MainRelationShipsPage(),
    EventsPage(),
    PurposesPage(),
    ArchivePage(),
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pageController.addListener(() {
      if (pageController.page != currentIndex) {
        currentIndex = pageController.page!.toInt();
        streamController.add('');
      }
    });

    return Scaffold(
      bottomNavigationBar: bottomNavigator(),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: pages,
          ),
        ],
      ),
    );
  }

  Widget bottomNavigator() {
    TextStyle styleSelect = const TextStyle(
        fontWeight: FontWeight.w700, fontSize: 12, color: ColorStyles.redColor);
    TextStyle styleUnSelect = const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12,
        color: ColorStyles.greyColor);

    return StreamBuilder(
      stream: streamController.stream,
      builder: (context, snapshot) {
        return Container(
          height: 100.h,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(bottom: 26.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => pageController.jumpToPage(0),
                  child: Container(
                    width: 93.w,
                    height: 74.h,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 11.h),
                        SvgPicture.asset(
                          SvgImg.relationships,
                          height: 32.h,
                          width: 37.w,
                          color: currentIndex == 0
                              ? ColorStyles.redColor
                              : Colors.grey,
                        ),
                        SizedBox(height: 12.h),
                        Text('Отношения',
                            style: currentIndex == 0
                                ? styleSelect
                                : styleUnSelect),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => pageController.jumpToPage(1),
                  child: Container(
                    width: 93.w,
                    height: 74.h,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 11.h),
                        SvgPicture.asset(
                          SvgImg.events,
                          height: 32.h,
                          width: 28.24.w,
                          color: currentIndex == 1
                              ? ColorStyles.redColor
                              : Colors.grey,
                        ),
                        SizedBox(height: 12.h),
                        Text('События',
                            style: currentIndex == 1
                                ? styleSelect
                                : styleUnSelect),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => pageController.jumpToPage(2),
                  child: Container(
                    width: 93.w,
                    height: 74.h,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 11.h),
                        SvgPicture.asset(
                          SvgImg.purposes,
                          height: 32.h,
                          width: 32.w,
                          color: currentIndex == 2
                              ? ColorStyles.redColor
                              : Colors.grey,
                        ),
                        SizedBox(height: 12.h),
                        Text('Цели',
                            style: currentIndex == 2
                                ? styleSelect
                                : styleUnSelect),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => pageController.jumpToPage(3),
                  child: Container(
                    width: 93.w,
                    height: 74.h,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 11.h),
                        SvgPicture.asset(
                          SvgImg.archive,
                          height: 32.h,
                          width: 29.26.w,
                          color: currentIndex == 3
                              ? ColorStyles.redColor
                              : Colors.grey,
                        ),
                        SizedBox(height: 12.h),
                        Text('Архив',
                            style: currentIndex == 3
                                ? styleSelect
                                : styleUnSelect),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
