import 'dart:async';
import 'dart:math';
import 'package:be_loved/core/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAnimationItemRelationships extends StatefulWidget {
  // final VoidCallback func;
  final Function(int) delete;
  final int index;
  const CustomAnimationItemRelationships({
    Key? key,
    // required this.func,
    required this.delete,
    required this.index,
  }) : super(key: key);

  @override
  State<CustomAnimationItemRelationships> createState() =>
      _CustomAnimationItemRelationshipsState();
}

class _CustomAnimationItemRelationshipsState
    extends State<CustomAnimationItemRelationships>
    with TickerProviderStateMixin {
  final streamController = StreamController<bool>();

  // AnimationController? _controllerAnimationRow;
  ScrollController scrollController = ScrollController();

  double rotate = pi / 4;

  TextStyle style = const TextStyle(
      fontWeight: FontWeight.w700, fontSize: 12, color: greyColor);

  @override
  void initState() {
    super.initState();

    streamController.add(true);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: streamController.stream,
      initialData: false,
      builder: (context, snapshot) {
        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.direction > 0) {
              scrollController.animateTo(55.w,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic);
            } else {
              scrollController.animateTo(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutCubic);
            }
          },
          child: AnimatedContainer(
            curve: Curves.ease,
            duration: const Duration(milliseconds: 1000),
            height: snapshot.data! ? 155.h : 0.h,
            width: 378.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
            ),
            clipBehavior: Clip.hardEdge,
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: AnimatedContainer(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 1000),
                height: snapshot.data! ? 155.h : 0.h,
                width: 378.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.white,
                ),
                clipBehavior: Clip.hardEdge,
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Stack(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 11.h, horizontal: 20.w),
                              child: SizedBox(
                                width: 338.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Предстоящее событие',
                                          style: TextStyle(
                                            color: greyColor,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w700,
                                            height: 1,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'Через 4 дня',
                                          style: TextStyle(
                                            color: const Color.fromRGBO(
                                                128, 74, 142, 1),
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w800,
                                            height: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    AnimatedContainer(
                                      curve: Curves.ease,
                                      duration:
                                          const Duration(milliseconds: 1000),
                                      height: snapshot.data! ? 19.h : 0.h,
                                    ),
                                    Text(
                                      'Годовщина',
                                      style: TextStyle(
                                          color: const Color.fromRGBO(
                                              23, 23, 23, 1),
                                          fontSize: 50.sp,
                                          fontWeight: FontWeight.w800,
                                          height: 1),
                                    ),
                                    AnimatedContainer(
                                      curve: Curves.ease,
                                      duration:
                                          const Duration(milliseconds: 1000),
                                      height: snapshot.data! ? 9.h : 0.h,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Завтра:',
                                          style: TextStyle(
                                              color: greyColor,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w700,
                                              height: 1),
                                        ),
                                        SizedBox(width: 10.w),
                                        Text(
                                          'Арбузный вечер',
                                          style: TextStyle(
                                              color: greyColor,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Container(
                                  height: 70.h,
                                  width: 55.w,
                                  color: greyColor2,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/setting.svg'),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    streamController.add(false);
                                    Future.delayed(Duration(milliseconds: 1000))
                                        .then((value) {
                                      // widget.delete(widget.index);
                                    });
                                  },
                                  child: Container(
                                    height: 70.h,
                                    width: 55.w,
                                    color: redColor,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/icons/trash.svg'),
                                      ],
                                    ),
                                  ),
                                )
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
          ),
        );
      },
    );
  }

  // void closeOpen(bool state) {
  // if (!_controllerAnimationRotate!.isAnimating) {
  //   if (_controllerAnimationRotate!.isCompleted) {
  //     _controllerAnimationRotate!.reverse();
  //   } else {
  //     _controllerAnimationRotate!.forward(from: rotate);
  //   }
  //   streamController.add(!state);
  // }

  //   if (_controllerAnimationRow!.isCompleted) {
  //     _controllerAnimationRow!.reverse();
  //   } else {
  //     _controllerAnimationRow!.forward(from: 0.0);
  //   }
  // }
}
