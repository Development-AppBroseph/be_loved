import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/home/data/models/home/hashTag.dart';
import 'package:be_loved/features/profile/presentation/widget/grey_line_for_bottomsheet.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

class AddEventBottomsheet extends StatefulWidget {
  const AddEventBottomsheet({Key? key}) : super(key: key);

  @override
  State<AddEventBottomsheet> createState() => _AddEventBottomsheetState();
}

class _AddEventBottomsheetState extends State<AddEventBottomsheet> {
  List<Widget> widgets = [];

  List<HashTagData> hashTags = [
    HashTagData(title: 'Важно', type: TypeHashTag.main),
    HashTagData(title: 'Арбуз', type: TypeHashTag.user),
    HashTagData(title: 'Название', type: TypeHashTag.custom),
    HashTagData(type: TypeHashTag.add),
  ];
  ScrollController scrollController = ScrollController();
  TextStyle style1 = TextStyle(
      color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15.sp);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: CupertinoCard(
        radius: BorderRadius.vertical(
          top: Radius.circular(80.r),
        ),
        elevation: 0,
        margin: EdgeInsets.zero,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutQuint,
          height: 750.h,
          width: MediaQuery.of(context).size.width,
          color: const Color.fromRGBO(0, 0, 0, 0),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 5.h,
                    width: 100.w,
                    margin: EdgeInsets.only(top: 7.h, bottom: 10.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: const Color(0xff969696)),
                  ),
                  Text(
                    'Добавить событие',
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: const Color(0xff969696),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: 140.h,
                    width: 378.w,
                    margin: EdgeInsets.only(top: 18.h, bottom: 34.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xff2C2C2E),
                        width: 1.w,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 20.w,
                        right: 20.w,
                        top: 11.h,
                        bottom: 22.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Например:',
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  color: const Color(0xff969696),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Завтра',
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  color: const Color(0xffFF1D1D),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            'Годовщина',
                            style: TextStyle(
                              fontFamily: "Inter",
                              color: const Color(0xff171717),
                              fontSize: 50.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Выбрать событие',
                      style: TextStyle(
                        fontFamily: "Inter",
                        color: const Color(0xff171717),
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 35.h, bottom: 25.h),
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

                            return CupertinoCard(
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
                                    // decoration: BoxDecoration(
                                    //   border: hashTags[index].type == TypeHashTag.add
                                    //       ? Border.all(color: ColorStyles.greyColor)
                                    //       : null,
                                    //   borderRadius: BorderRadius.circular(10.r),
                                    //   color: color,
                                    // ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25.w, vertical: 10.h),
                                    child: Center(
                                        child: hashTags[index].type ==
                                                TypeHashTag.add
                                            ? SizedBox(
                                                height: 34.h,
                                                width: 34.w,
                                                child: Transform.rotate(
                                                    angle: pi / 4,
                                                    child: SvgPicture.asset(
                                                        SvgImg.add)),
                                              )
                                            : Text('#${hashTags[index].title}',
                                                style: style1)),
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      },
                      itemCount: hashTags.length,
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Предстоящее событие:',
                              style: TextStyle(
                                fontFamily: "Inter",
                                color: const Color(0xff171717),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 6.h),
                              child: Text(
                                "1 событие",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  color: const Color(0xff969696),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color(0xff171717),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 17.h, bottom: 26.h),
                    height: 1.h,
                    width: 378.w,
                    color: const Color(0xff969696),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 35.w),
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        children: List.generate(
                          widgets.length,
                          (index) => Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: SizedBox(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Предстоящее событие:',
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          color: const Color(0xff171717),
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 6.h),
                                        child: Text(
                                          "1 событие",
                                          style: TextStyle(
                                            fontFamily: "Inter",
                                            color: const Color(0xff969696),
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  const Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xff171717),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        widgets.add(
                          Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: SizedBox(
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Предстоящее событие:',
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          color: const Color(0xff171717),
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 6.h),
                                        child: Text(
                                          "1 событие",
                                          style: TextStyle(
                                            fontFamily: "Inter",
                                            color: const Color(0xff969696),
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  const Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color(0xff171717),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                    },
                    child: Container(
                      height: 55.h,
                      width: 378,
                      margin: EdgeInsets.only(bottom: 30.h),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff969696),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(
                            flex: 3,
                          ),
                          Text(
                            "Новое событие",
                            style: TextStyle(
                              fontFamily: "Inter",
                              color: const Color(0xff969696),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 74.w,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 18.w),
                            child: const Icon(
                              Icons.add,
                              color: Color(0xff969696),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
