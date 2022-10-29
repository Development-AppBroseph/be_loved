import 'dart:async';
import 'dart:math';
import 'package:be_loved/core/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAddAnimationButton extends StatefulWidget {
  final VoidCallback func;
  const CustomAddAnimationButton({Key? key, required this.func})
      : super(key: key);

  @override
  State<CustomAddAnimationButton> createState() =>
      _CustomAddAnimationButtonState();
}

class _CustomAddAnimationButtonState extends State<CustomAddAnimationButton>
    with TickerProviderStateMixin {
  final streamController = StreamController<bool>();

  AnimationController? _controllerAnimationRotate;
  AnimationController? _controllerAnimationRow;

  double rotate = pi / 4;

  TextStyle style = const TextStyle(
      fontWeight: FontWeight.w700, fontSize: 12, color: greyColor);

  @override
  void initState() {
    super.initState();
    _controllerAnimationRotate = AnimationController(
        vsync: this,
        lowerBound: pi / 4,
        upperBound: pi / 2,
        animationBehavior: AnimationBehavior.preserve,
        duration: const Duration(milliseconds: 900));
    _controllerAnimationRotate!.addListener(() {
      setState(() {
        rotate = _controllerAnimationRotate!.value;
      });
    });

    _controllerAnimationRow = AnimationController(
        vsync: this,
        lowerBound: 0,
        upperBound: 70.h,
        animationBehavior: AnimationBehavior.preserve,
        duration: const Duration(milliseconds: 900));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: streamController.stream,
        initialData: false,
        builder: (context, snapshot) {
          return Stack(
            children: [
              AnimatedContainer(
                curve: Curves.ease,
                duration: const Duration(milliseconds: 1000),
                height: snapshot.data! ? 100.h : 70.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: greyColor,
                    width: 1,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 9.w, right: 20.w),
                      child: AnimatedAlign(
                        alignment: snapshot.data!
                            ? Alignment.centerRight
                            : Alignment.center,
                        curve: Curves.ease,
                        duration: const Duration(milliseconds: 1000),
                        child: SizedBox(
                          width: 70.w,
                          height: 70.h,
                          child: GestureDetector(
                            onTap: () {
                              closeOpen(snapshot.data!);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(right: 0.w),
                              child: Transform.rotate(
                                  angle: rotate,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SvgPicture.asset('assets/icons/add.svg'),
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 1000),
                top: snapshot.data! ? 0 : 70.h,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 15.h, bottom: 15.h, right: 118.w, left: 20.w),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 70.h,
                        height: 70.w,
                        child: GestureDetector(
                          onTap: () {
                            widget.func();
                            //                     if (_controllerAnimationRow!.isCompleted) {
                            //   print('objectadddd');
                            //   // _controllerAnimationRow!.reverse();
                            // }
                            closeOpen(snapshot.data!);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/events.svg',
                                color: greyColor,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/purposes.svg',
                                color: Colors.grey,
                                height: 38.h,
                                width: 38.w,
                              ),
                              SizedBox(height: 12.h),
                              Text('Цели', style: style),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      SizedBox(
                        width: 70.h,
                        height: 70.w,
                        child: GestureDetector(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/archive.svg',
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
                        color: greyColor,
                      )
                    ],
                  ),
                ),
              ),
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

    if (_controllerAnimationRow!.isCompleted) {
      _controllerAnimationRow!.reverse();
    } else {
      _controllerAnimationRow!.forward(from: 0.0);
    }
  }
}
