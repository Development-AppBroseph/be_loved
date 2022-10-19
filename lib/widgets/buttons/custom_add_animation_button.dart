import 'dart:async';
import 'dart:math';
import 'package:be_loved/core/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAddAnimationButton extends StatefulWidget {
  const CustomAddAnimationButton({Key? key}) : super(key: key);

  @override
  State<CustomAddAnimationButton> createState() =>
      _CustomAddAnimationButtonState();
}

class _CustomAddAnimationButtonState extends State<CustomAddAnimationButton>
    with TickerProviderStateMixin {
  final streamController = StreamController<bool>();

  AnimationController? _controllerAnimationRotate;

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
        duration: const Duration(milliseconds: 1000));
    _controllerAnimationRotate!.addListener(() {
      setState(() {
        rotate = _controllerAnimationRotate!.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: streamController.stream,
        initialData: false,
        builder: (context, snapshot) {
          return AnimatedContainer(
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
                  padding:
                      EdgeInsets.only(top: 15.h, bottom: 15.h, right: 99.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/events.svg',
                              color: greyColor,
                            ),
                            SizedBox(height: 12.h),
                            Text('События', style: style),
                          ],
                        ),
                      ),
                      GestureDetector(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/purposes.svg',
                              color: Colors.grey,
                            ),
                            SizedBox(height: 12.h),
                            Text('Цели', style: style),
                          ],
                        ),
                      ),
                      GestureDetector(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/archive.svg',
                              color: Colors.grey,
                            ),
                            SizedBox(height: 12.h),
                            Text('Архив', style: style),
                          ],
                        ),
                      ),
                      Container(
                        height: 55.h,
                        width: 1.w,
                        color: greyColor,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 34.w),
                  child: AnimatedAlign(
                    alignment: snapshot.data!
                        ? Alignment.centerRight
                        : Alignment.center,
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 1000),
                    child: GestureDetector(
                      onTap: () {
                        streamController.add(!snapshot.data!);
                        if (_controllerAnimationRotate!.isCompleted) {
                          _controllerAnimationRotate!.reverse();
                        } else {
                          _controllerAnimationRotate!.forward(from: 0.0);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 0.w),
                        child: Transform.rotate(
                            angle: rotate,
                            child: SvgPicture.asset('assets/icons/add.svg')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
