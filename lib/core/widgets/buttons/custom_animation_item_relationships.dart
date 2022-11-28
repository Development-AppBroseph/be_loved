import 'dart:async';
import 'dart:math';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/utils/helpers/date_time_helper.dart';
import 'package:be_loved/core/utils/helpers/events.dart';
import 'package:be_loved/core/utils/helpers/text_size.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/texts/next_text_widget.dart';
import 'package:be_loved/core/widgets/texts/today_text_widget.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/create_event_modal.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAnimationItemRelationships extends StatefulWidget {
  final Function(int) delete;
  final Function(int id) onDetail;
  final int index;
  final EventEntity events;
  const CustomAnimationItemRelationships({
    Key? key,
    required this.delete,
    required this.index,
    required this.onDetail,
    required this.events,
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
    EventsBloc eventsBloc = context.read<EventsBloc>();
    return StreamBuilder<bool>(
      stream: streamController.stream,
      initialData: false,
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
            duration: const Duration(milliseconds: 600),
            opacity: snapshot.data! ? 1 : 0,
            curve: Curves.easeInOutQuint,
            child: AnimatedContainer(
              curve: Curves.easeInOutQuint,
              duration: const Duration(milliseconds: 600),
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
                  duration: const Duration(milliseconds: 600),
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
                    padding: EdgeInsets.zero,
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
                                child: Container(
                                  height: 140.h,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 11.h, horizontal: 20.w),
                                  child: SizedBox(
                                    width: 338.w,
                                    height: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        widget.events.datetimeString == '0'
                                        ? TodayTextWidget()
                                        : Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Предстоящее событие',
                                              style: TextStyle(
                                                color: ColorStyles.greyColor,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w700,
                                                height: 1,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              widget.events.datetimeString == '0'
                                              ? 'Сегодня'
                                              : '${checkDays(widget.events.datetimeString)}',
                                              style: TextStyle(
                                                color: getColorFromDays(widget.events.datetimeString, widget.events.important),
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w800,
                                                height: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                        AnimatedContainer(
                                          curve: Curves.easeInOutQuint,
                                          duration: const Duration(
                                              milliseconds: 600),
                                          height: snapshot.data! 
                                          ? (widget.events.datetimeString == '0' && eventsBloc.events.first.id == widget.events.id 
                                            ? 10.h 
                                            : eventsBloc.events.first.id == widget.events.id  
                                            ? 19.h 
                                            : (widget.events.datetimeString == '0' ? 23.h : 36.h)+4.h) 
                                          : 0.h,
                                        ),
                                        Text(
                                          widget.events.title,
                                          style: TextStyle(
                                              color: const Color.fromRGBO(
                                                  23, 23, 23, 1),
                                              fontSize: homeWidgetTextSize(widget.events.title).sp,
                                              fontWeight: FontWeight.w800,
                                              height: 1),
                                        ),
                                        AnimatedContainer(
                                          curve: Curves.easeInOutQuint,
                                          duration: const Duration(
                                              milliseconds: 600),
                                          height: snapshot.data! ? 9.h : 0.h,
                                        ),
                                        // widget.index == 0
                                        // ? 
                                        NextEventTextWidget(eventEntity: widget.events)
                                        //  SizedBox(height: 10.h,)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                physics: NeverScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        widget.onDetail(widget.events.id);
                                      },
                                      child: Container(
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
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        streamController.add(false);
                                        scrollController.animateTo(0,
                                            duration: const Duration(
                                                milliseconds: 600),
                                            curve: Curves.easeInOutQuint);
                                        Future.delayed(
                                                Duration(milliseconds: 600))
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
