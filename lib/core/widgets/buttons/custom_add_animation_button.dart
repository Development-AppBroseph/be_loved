import 'dart:async';
import 'dart:math';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAddAnimationButton extends StatefulWidget {
  final VoidCallback func;
  final VoidCallback funcArchive;
  final VoidCallback funcPurpose;
  const CustomAddAnimationButton({Key? key, required this.func, required this.funcPurpose, required this.funcArchive})
      : super(key: key);

  @override
  State<CustomAddAnimationButton> createState() =>
      _CustomAddAnimationButtonState();
}

class _CustomAddAnimationButtonState extends State<CustomAddAnimationButton>
    with TickerProviderStateMixin {
  final streamController = StreamController<bool>();
  int milisec = 800;

  AnimationController? _controllerAnimationRotate;
  // AnimationController? _controllerAnimationRow;

  double rotate = pi / 4;

  TextStyle style = const TextStyle(
      fontWeight: FontWeight.w700, fontSize: 12, color: ColorStyles.greyColor);

  @override
  void initState() {
    super.initState();
    _controllerAnimationRotate = AnimationController(
        vsync: this,
        lowerBound: pi / 4,
        upperBound: pi / 2,
        animationBehavior: AnimationBehavior.normal,
        duration: Duration(milliseconds: milisec - 300));
    _controllerAnimationRotate!.addListener(() {
      setState(() {
        rotate = _controllerAnimationRotate!.value;
      });
    });

    // _controllerAnimationRow = AnimationController(
    //     vsync: this,
    //     lowerBound: 0,
    //     upperBound: 70.h,
    //     animationBehavior: AnimationBehavior.preserve,
    //     duration: Duration(milliseconds: milisec));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: streamController.stream,
        initialData: false,
        builder: (context, snapshot) {
          return Stack(
            children: [
              CupertinoCard(
                elevation: 0,
                margin: EdgeInsets.zero,
                radius: BorderRadius.circular(40.r),
                color: ColorStyles.greyColor,
                child: AnimatedContainer(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: milisec - 200),
                  height: snapshot.data! ? 100.h : 70.h,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(20.r),
                  //   border: Border.all(
                  //     color: ColorStyles.greyColor,
                  //     width: 1,
                  //   ),
                  // ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                          child: CupertinoCard(
                        elevation: 0,
                        radius: BorderRadius.circular(37.r),
                        margin: EdgeInsets.all(1.w),
                        color: ClrStyle.backToBlack2C[sl<AuthConfig>().idx],
                      )),
                      Padding(
                        padding: EdgeInsets.only(left: 9.w, right: 9.w),
                        child: AnimatedAlign(
                          alignment: snapshot.data!
                              ? Alignment.centerRight
                              : Alignment.center,
                          curve: Curves.ease,
                          duration: Duration(milliseconds: milisec - 200),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: milisec),
                            color: Colors.transparent,
                            curve: Curves.ease,
                            // width: snapshot.data! ? 90.w : 378.w,
                            // height: snapshot.data! ? 100.h : 70.h, // 70.h,
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 33.79.w),
                              child: Transform.rotate(
                                  angle: rotate,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SvgPicture.asset(SvgImg.add),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedPositioned(
                curve: Curves.ease,
                duration: Duration(milliseconds: milisec - 200),
                top: snapshot.data! ? 0 : 70.h,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 15.h, bottom: 15.h, right: 118.w, left: 20.w),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 70.w,
                        height: 70.h,
                        child: GestureDetector(
                          onTap: () {
                            widget.func();
                            closeOpen(snapshot.data!);
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                SvgImg.events,
                                color: ColorStyles.greyColor,
                                height: 38.h,
                                width: 34.w,
                              ),
                              SizedBox(height: 12.h),
                              Text('Событие', style: style),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      SizedBox(
                        width: 70.h,
                        height: 70.w,
                        child: GestureDetector(
                          onTap: () {
                            widget.funcPurpose();
                            closeOpen(snapshot.data!);
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                SvgImg.purposes,
                                color: Colors.grey,
                                height: 38.h,
                                width: 38.w,
                              ),
                              SizedBox(height: 12.h),
                              Text('Цель', style: style),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      SizedBox(
                        width: 70.h,
                        height: 70.w,
                        child: GestureDetector(
                          onTap: () {
                            widget.funcArchive();
                            closeOpen(snapshot.data!);
                          },
                          behavior: HitTestBehavior.translucent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                SvgImg.archive,
                                color: Colors.grey,
                                height: 38.h,
                                width: 34.74.w,
                              ),
                              SizedBox(height: 12.h),
                              Text('Архив', style: style),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 19.w),
                      Container(
                        height: 55.h,
                        width: 1.w,
                        color: ColorStyles.greyColor,
                      )
                    ],
                  ),
                ),
              ),
              snapshot.data!
                  ? Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.only(left: 279.w),
                        child: GestureDetector(
                          onTap: () {
                            closeOpen(snapshot.data!);
                          },
                        ),
                      ),
                    )
                  : Positioned.fill(
                      child: GestureDetector(
                        onTap: () {
                          closeOpen(snapshot.data!);
                        },
                      ),
                    )
            ],
          );
        });
  }

  void closeOpen(bool state) {
    if (!_controllerAnimationRotate!.isAnimating) {
      if (_controllerAnimationRotate!.isCompleted) {
        _controllerAnimationRotate!.reverse();
      } else {
        _controllerAnimationRotate!.forward(from: rotate);
      }
      streamController.add(!state);
    }

    // if (_controllerAnimationRow!.isCompleted) {
    //   _controllerAnimationRow!.reverse();
    // } else {
    //   _controllerAnimationRow!.forward(from: 0.0);
    // }
  }
}
