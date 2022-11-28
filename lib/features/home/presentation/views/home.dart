import 'dart:async';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/views/archive/archive.dart';
import 'package:be_loved/features/home/presentation/views/events/view/main_event_page.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/main_page/events_page.dart';
import 'package:be_loved/features/home/presentation/views/purposes/purposes_page.dart';
import 'package:be_loved/features/home/presentation/views/relationships/main_page.dart';
import 'package:be_loved/features/home/presentation/views/relationships/main_relation_ships_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants/colors/color_styles.dart';
import '../bloc/tags/tags_bloc.dart';
import 'events/view/event_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageController = PageController();

  final streamController = StreamController<String>();

  int currentIndex = 0;

  List<Widget> pages = [
    const MainPage(),
    const MainEventPage(),//(nextPage: (int id) {  },),//MainEventPage
    PurposesPage(),
    ArchivePage(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<EventsBloc>().add(GetEventsEvent());
    context.read<AuthBloc>().add(GetUser());
    context.read<TagsBloc>().add(GetTagsEvent());

    pageController.addListener(() {
      if (pageController.page != currentIndex) {
        Future.delayed(Duration(milliseconds: 50),(){
        // streamController.add('');
        setState(() {
          currentIndex = pageController.page!.toInt();
          
        });
        });
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    streamController.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // var loader = showLoaderWrapper(context);
        if (state is GetUserSuccess || state is GetUserError || state is RefreshUser) {
          // Loader.hide();
          return Scaffold(
            bottomNavigationBar: bottomNavigator(),
            backgroundColor: currentIndex == 1 ? Colors.white : null,
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
        } else {
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/icons/heart.svg',
              color: ColorStyles.redColor,
            ),
          );
        }
      },
    );
  }

  Widget bottomNavigator() {
    TextStyle styleSelect = const TextStyle(
        fontWeight: FontWeight.w700, fontSize: 12, color: ColorStyles.redColor);
    TextStyle styleUnSelect = const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12,
        color: ColorStyles.greyColor);

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
  }
}
