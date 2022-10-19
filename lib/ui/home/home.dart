import 'dart:async';
import 'package:be_loved/core/helpers/constants.dart';
import 'package:be_loved/ui/home/archive/archive.dart';
import 'package:be_loved/ui/home/events/events_page.dart';
import 'package:be_loved/ui/home/purposes/purposes_page.dart';
import 'package:be_loved/ui/home/relationships/relation_ships_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final pageController = PageController();
  final streamController = StreamController();
  int currentIndex = 0;

  List<Widget> pages = [
    RelationShipsPage(),
    EventsPage(),
    PurposesPage(),
    ArchivePage(),
  ];

  @override
  Widget build(BuildContext context) {
    pageController.addListener(() {
      if (pageController.page != currentIndex) {
        currentIndex = pageController.page!.toInt();
        streamController.add('');
      }
    });

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: pages,
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomNavigator()),
        ],
      ),
    );
  }

  Widget bottomNavigator() {
    TextStyle styleSelect = const TextStyle(
        fontWeight: FontWeight.w700, fontSize: 12, color: redColor);
    TextStyle styleUnSelect = const TextStyle(
        fontWeight: FontWeight.w700, fontSize: 12, color: greyColor);

    return StreamBuilder(
      stream: streamController.stream,
      builder: (context, snapshot) {
        return ColoredBox(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(top: 11.h, bottom: 32.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => pageController.jumpToPage(0),
                  child: SizedBox(
                    width: 93.w,
                    height: 74.h,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/relationships.svg',
                          color: currentIndex == 0 ? redColor : Colors.grey,
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
                  child: SizedBox(
                    width: 93.w,
                    height: 74.h,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/events.svg',
                          color: currentIndex == 1 ? redColor : Colors.grey,
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
                  child: SizedBox(
                    width: 93.w,
                    height: 74.h,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/purposes.svg',
                          color: currentIndex == 2 ? redColor : Colors.grey,
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
                  child: SizedBox(
                    width: 93.w,
                    height: 74.h,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/archive.svg',
                          color: currentIndex == 3 ? redColor : Colors.grey,
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
