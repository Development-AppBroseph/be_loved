import 'dart:math';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/data/models/home/hashTag.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/user_events.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'tag_modal.dart';

class AllEeventsPage extends StatefulWidget {
  final VoidCallback prevPage;
  const AllEeventsPage({Key? key, required this.prevPage}) : super(key: key);

  @override
  State<AllEeventsPage> createState() => _AllEeventsPageState();
}

class _AllEeventsPageState extends State<AllEeventsPage> {
  final PageController _pageController = PageController();
  ScrollController scrollController = ScrollController();

  int countPage = 0;
  List<HashTagData> hashTags = [
    HashTagData(title: 'Важно', type: TypeHashTag.main),
    HashTagData(title: 'Арбуз', type: TypeHashTag.user),
    HashTagData(title: 'Название', type: TypeHashTag.custom),
    HashTagData(type: TypeHashTag.add),
  ];
  bool isSelectedAll = false;
  TextStyle style1 = TextStyle(
      color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15.sp);
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 75.h, bottom: 54.h, left: 35.w),
            child: GestureDetector(
              onTap: () => widget.prevPage(),
              child: SizedBox(
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 28,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20.w),
                      child: Text(
                        'Назад',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20.sp,
                          color: const Color(0xff2C2C2E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 55.h,
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                setState(() {
                  countPage = value;
                });
              },
              children: [
                Row(
                  children: [
                    Container(
                      height: 55.h,
                      width: 109.w,
                      margin: EdgeInsets.only(left: 25.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(
                          color: const Color(0xff969696),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "0/30",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff969696),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      margin: EdgeInsets.only(right: 25.w),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              countPage = 1;
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 600),
                                  curve: Curves.easeInOutQuint);
                            },
                            child: Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: const Color(0xff969696),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  SvgImg.edit,
                                  height: 19.h,
                                  width: 19.w,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Container(
                            height: 55.h,
                            width: 55.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: const Color(0xff20CB83),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                size: 35,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        'Выделено: 0 событий',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 20.sp,
                          color: const Color(0xff2C2C2E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    isSelectedAll
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                countPage = 0;
                                _pageController.previousPage(
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeInOutQuint);
                              });
                            },
                            child: Container(
                              height: 55.h,
                              width: 55.w,
                              margin: EdgeInsets.only(right: 10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: const Color(0xffFF1D1D),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  SvgImg.bin,
                                  height: 22.h,
                                  width: 24.w,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          countPage = 0;
                          _pageController.previousPage(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOutQuint);
                        });
                      },
                      child: Container(
                        height: 55.h,
                        width: 55.w,
                        margin: EdgeInsets.only(right: 25.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: const Color(0xffFF1D1D),
                              width: 1,
                            )),
                        child: Center(
                          child: SvgPicture.asset(
                            SvgImg.add,
                            height: 19.h,
                            width: 19.w,
                            color: const Color(0xffFF1D1D),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 39.h),
            height: 38.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                      left: index == 0 ? 25.w : 15.w,
                      right: index == hashTags.length - 1 ? 25.w : 0),
                  child: Builder(builder: (context) {
                    Color color;
                    switch (hashTags[index].type) {
                      case TypeHashTag.main:
                        color = ColorStyles.redColor;
                        break;
                      case TypeHashTag.user:
                        color = ColorStyles.accentColor;
                        break;
                      case TypeHashTag.custom:
                        color = ColorStyles.blueColor;
                        break;
                      default:
                        color = Colors.transparent;
                    }

                    return GestureDetector(
                      onTap: () => showMaterialModalBottomSheet(
                          context: context,
                          animationCurve: Curves.easeInOutQuint,
                          duration: const Duration(milliseconds: 600),
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return TagModal(typeHashTag: hashTags[index].type);
                          }),
                      child: CupertinoCard(
                        color: hashTags[index].type == TypeHashTag.add
                            ? ColorStyles.greyColor
                            : color,
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        radius: BorderRadius.circular(20.r),
                        child: Stack(
                          children: [
                            if (hashTags[index].type == TypeHashTag.add)
                              Positioned.fill(
                                child: CupertinoCard(
                                  elevation: 0,
                                  margin: EdgeInsets.all(1.w),
                                  radius: BorderRadius.circular(17.r),
                                  color: ColorStyles.backgroundColorGrey,
                                ),
                              ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25.w, vertical: 10.h),
                              child: Center(
                                  child: hashTags[index].type == TypeHashTag.add
                                      ? SizedBox(
                                          height: 34.h,
                                          width: 34.w,
                                          child: Transform.rotate(
                                              angle: pi / 4,
                                              child:
                                                  SvgPicture.asset(SvgImg.add)),
                                        )
                                      : Text('#${hashTags[index].title}',
                                          style: style1)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              },
              itemCount: hashTags.length,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 39.h),
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                scrollDirection: Axis.vertical,
                itemCount: 30,
                physics: const ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      setState(() {
                        if (isSelectedAll) {
                          isSelectedAll = false;
                        } else {
                          isSelectedAll = true;
                        }
                      });
                    },
                    child: UserEvents(
                      countPage: countPage,
                      isSelectedAll: isSelectedAll,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
