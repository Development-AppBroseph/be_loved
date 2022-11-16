import 'dart:async';
import 'dart:math';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/utils/helpers/date_time_helper.dart';
import 'package:be_loved/core/utils/helpers/events.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAnimationItemRelationships extends StatefulWidget {
  final Function(int) delete;
  final int index;
  final EventEntity events;
  const CustomAnimationItemRelationships({
    Key? key,
    required this.delete,
    required this.index,
    required this.event,
    required this.nextEvent,
  }) : super(key: key);

  @override
  State<CustomAnimationItemRelationships> createState() =>
      _CustomAnimationItemRelationshipsState();
}

enum DirectionAnimation { left, right }

class _CustomAnimationItemRelationshipsState
    extends State<CustomAnimationItemRelationships>
    with TickerProviderStateMixin {
  final streamController = StreamController<bool>();
  ScrollController scrollController = ScrollController();

  double rotate = pi / 4;

  TextStyle style = const TextStyle(
      fontWeight: FontWeight.w700, fontSize: 12, color: ColorStyles.greyColor);

  @override
  void initState() {
    super.initState();

    streamController.add(true);
  }

  double pos = 0;

  late DirectionAnimation directionAnimation;

  @override
  Widget build(BuildContext context) {
    streamController.add(true);
    return StreamBuilder<bool>(
      stream: streamController.stream,
      initialData: true,
      builder: (context, snapshot) {
        return GestureDetector(
          onHorizontalDragStart: (details) {
            pos = details.localPosition.dx;
          },
          onHorizontalDragUpdate: (details) {
            if (pos > details.localPosition.dx) {
              directionAnimation = DirectionAnimation.left;
              if (scrollController.offset < 55.w) {
                scrollController.jumpTo(scrollController.offset + 3);
              }
            } else {
              directionAnimation = DirectionAnimation.right;
              if (scrollController.offset > 0) {
                scrollController.jumpTo(scrollController.offset - 3);
              }
            }
            pos = details.localPosition.dx;
          },
          onHorizontalDragEnd: (details) {
            if (directionAnimation == DirectionAnimation.right) {
              scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOutQuint,
              );
            } else {
              scrollController.animateTo(
                55.w,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOutQuint,
              );
            }
          },
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 1000),
            opacity: snapshot.data! ? 1 : 0,
            curve: Curves.easeInOutQuint,
            child: AnimatedContainer(
              curve: Curves.easeInOutQuint,
              duration: const Duration(milliseconds: 1000),
              height: snapshot.data! ? 155.h : 0.h,
              width: 378.w,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(20.r),
              // ),
              // clipBehavior: Clip.hardEdge,
              child: Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: AnimatedContainer(
                  curve: Curves.easeInOutQuint,
                  duration: const Duration(milliseconds: 1000),
                  height: snapshot.data! ? 155.h : 0.h,
                  width: 378.w,
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(20.r),
                  //   color: Colors.white,
                  // ),
                  // clipBehavior: Clip.hardEdge,
                  child: CupertinoCard(
                    radius: BorderRadius.circular(40.r),
                    color: Colors.white,
                    elevation: 0,
                    margin: EdgeInsets.zero,
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
                                physics: const NeverScrollableScrollPhysics(),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 11.h, horizontal: 20.w),
                                  child: SizedBox(
                                    width: 338.w,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            if (widget.event.datetime.day !=
                                                DateTime.now().day)
                                              Row(
                                                children: [
                                                  if (widget.event.image !=
                                                      null)
                                                    Text(
                                                      widget.event.image!,
                                                      style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        height: 1,
                                                      ),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  if (widget.event.image !=
                                                      null)
                                                    SizedBox(width: 4.92.w),
                                                  Text(
                                                    'Предстоящее событие',
                                                    style: TextStyle(
                                                      color:
                                                          ColorStyles.greyColor,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 1,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            else
                                              Text(
                                                '${checkDays(widget.event.datetime)}:',
                                                style: TextStyle(
                                                  color: _getTextColor(
                                                    widget.event.datetime,
                                                  ),
                                                  fontSize: 25.sp,
                                                  fontWeight: FontWeight.w800,
                                                  height: 1,
                                                ),
                                              ),
                                            const Spacer(),
                                            Text(
                                              'Через ${widget.events.datetimeString} ${checkDays(widget.events.datetimeString)}',
                                              style: TextStyle(
                                                color: const Color.fromRGBO(
                                                    128, 74, 142, 1),
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w800,
                                                height: 1,
                                              ),
                                          ],
                                        ),
                                        AnimatedContainer(
                                          curve: Curves.easeInOutQuint,
                                          duration: const Duration(
                                              milliseconds: 1000),
                                          height: snapshot.data!
                                              ? widget.nextEvent != null
                                                  ? 19.h
                                                  : 34.h
                                              : 0.h,
                                        ),
                                        Text(
                                          widget.events.title,
                                          style: TextStyle(
                                            color: const Color.fromRGBO(
                                                23, 23, 23, 1),
                                            fontSize: _getFontSize(
                                                widget.event.name.length),
                                            fontWeight: FontWeight.w800,
                                            height: 1,
                                          ),
                                        ),
                                        AnimatedContainer(
                                          curve: Curves.easeInOutQuint,
                                          duration: const Duration(
                                            milliseconds: 1000,
                                          ),
                                          height: snapshot.data! ? 9.h : 0.h,
                                        ),
                                        widget.index == 0 && context.read<EventsBloc>().events.any((element) => element.datetimeString == '1' || element.datetimeString == '0')
                                        ? Row(
                                          children: [
                                            Text(
                                              'Завтра:',
                                              style: TextStyle(
                                                  color: ColorStyles.greyColor,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w700,
                                                  height: 1),
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              context.read<EventsBloc>().events.where((element) => element.datetimeString == '1')
                                              .first.title,
                                              style: TextStyle(
                                                  color: ColorStyles.greyColor,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        ) : SizedBox(height: 10.h,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                physics: const NeverScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 70.h,
                                      width: 55.w,
                                      color: ColorStyles.greyColor2,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SvgPicture.asset(SvgImg.setting),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        streamController.add(false);
                                        scrollController.animateTo(
                                          0,
                                          duration: const Duration(
                                            milliseconds: 1000,
                                          ),
                                          curve: Curves.easeInOutQuint,
                                        );
                                        Future.delayed(const Duration(
                                                milliseconds: 1000))
                                            .then((value) {
                                          widget.delete(widget.index);
                                        });
                                      },
                                      child: Container(
                                        height: 70.h,
                                        width: 55.w,
                                        color: ColorStyles.redColor,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SvgPicture.asset(SvgImg.trash),
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
            ),
          ),
        );
      },
    );
  }


  Color _getTextColor(DateTime date) {
    int days = date.difference(DateTime.now()).inDays;

    if (days < 3) {
      return const Color.fromRGBO(255, 29, 29, 1);
    } else if (days == 3) {
      return const Color.fromRGBO(191, 51, 85, 1);
    } else if (days == 4) {
      return const Color.fromRGBO(128, 74, 142, 1);
    } else if (days == 5) {
      return const Color.fromRGBO(64, 97, 199, 1);
    } else if (days == 6) {
      return const Color.fromRGBO(1, 119, 255, 1);
    } else {
      return const Color.fromRGBO(150, 150, 150, 1);
    }
  }

  String checkDays(DateTime date) {
    int days = date.difference(DateTime.now()).inHours ~/ 24;
    String whenDate = '';
    if (DateTime.now().add(date.difference(DateTime.now())).day !=
        DateTime.now().day + days) {
      days++;
    }
    int lastNumber = int.parse(days.toString()[days.toString().length - 1]);
    print(lastNumber);
    if (days == 0) {
      whenDate = 'Сегодня';
      return whenDate;
    }
    if (days == 1) {
      whenDate = 'Завтра';
      return whenDate;
    }
    if (days > 5 && lastNumber < 10) return 'Через $days дней';
    if (days % 5 == 0) return 'Через $days дней';
    if (days == 11) return 'Через $days дней';
    if (lastNumber == 1) return 'Завтра';
    if (lastNumber == 2) return 'Через день';
    return 'Через $days дня';
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
