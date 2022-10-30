import 'dart:async';
import 'dart:math';
import 'package:be_loved/core/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CustomAnimationItemRelationships extends StatefulWidget {
  final VoidCallback func;
  const CustomAnimationItemRelationships({Key? key, required this.func})
      : super(key: key);

  @override
  State<CustomAnimationItemRelationships> createState() =>
      _CustomAnimationItemRelationshipsState();
}

class _CustomAnimationItemRelationshipsState
    extends State<CustomAnimationItemRelationships>
    with TickerProviderStateMixin {
  final streamController = StreamController<bool>();

  AnimationController? _controllerAnimationRow;

  double rotate = pi / 4;

  TextStyle style = const TextStyle(
      fontWeight: FontWeight.w700, fontSize: 12, color: greyColor);

  @override
  void initState() {
    super.initState();

    _controllerAnimationRow = AnimationController(
        vsync: this,
        lowerBound: 0,
        upperBound: 70.h,
        animationBehavior: AnimationBehavior.preserve,
        duration: const Duration(milliseconds: 900));

    _controllerAnimationRow!.forward(from: 0.0);
    _controllerAnimationRow!.reverse();
    streamController.add(true);
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
          height: snapshot.data! ? 140.h : 0.h,
          width: 378.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: Colors.white,
          ),
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 20.w),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              color: const Color.fromRGBO(128, 74, 142, 1),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      AnimatedContainer(
                        curve: Curves.ease,
                        duration: const Duration(milliseconds: 1000),
                        height: snapshot.data! ? 19.h : 0.h,
                      ),
                      Text(
                        'Годовщина',
                        style: TextStyle(
                            color: const Color.fromRGBO(23, 23, 23, 1),
                            fontSize: 50.sp,
                            fontWeight: FontWeight.w800,
                            height: 1),
                      ),
                      AnimatedContainer(
                        curve: Curves.ease,
                        duration: const Duration(milliseconds: 1000),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void closeOpen(bool state) {
    // if (!_controllerAnimationRotate!.isAnimating) {
    //   if (_controllerAnimationRotate!.isCompleted) {
    //     _controllerAnimationRotate!.reverse();
    //   } else {
    //     _controllerAnimationRotate!.forward(from: rotate);
    //   }
    //   streamController.add(!state);
    // }

    if (_controllerAnimationRow!.isCompleted) {
      _controllerAnimationRow!.reverse();
    } else {
      _controllerAnimationRow!.forward(from: 0.0);
    }
  }
}
