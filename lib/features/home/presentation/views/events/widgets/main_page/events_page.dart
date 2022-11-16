import 'dart:async';
import 'dart:math';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/utils/helpers/date_time_helper.dart';
import 'package:be_loved/core/utils/helpers/events_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/texts/day_text_widget.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/add_events_bottomsheet.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/create_event_modal.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../data/models/home/hashTag.dart';
import '../../../../../data/models/home/upcoming_info.dart';
import '../../../relationships/modals/add_event_modal.dart';

class MainEventsPage extends StatefulWidget {
  final VoidCallback nextPage;
  const MainEventsPage({Key? key, required this.nextPage}) : super(key: key);

  @override
  State<MainEventsPage> createState() => _MainEventsPageState();
}

class _MainEventsPageState extends State<MainEventsPage> {
  List<HashTagData> hashTags = [
    HashTagData(title: 'Важно', type: TypeHashTag.main),
    HashTagData(title: 'Арбуз', type: TypeHashTag.user),
    HashTagData(title: 'Название', type: TypeHashTag.custom),
    HashTagData(type: TypeHashTag.add),
  ];

  // List<UpcomingInfo> upComingInfo = [
  //   UpcomingInfo(
  //     title: 'Годовщина',
  //     subTitle: 'Beloved :)',
  //     days: 'Завтра',
  //   ),
  //   UpcomingInfo(
  //     title: 'Арбузный вечер',
  //     subTitle: 'Добавил(а) Никита Белых',
  //     days: 'Через 3 дня',
  //   ),
  //   UpcomingInfo(
  //     title: 'Я роняю запад',
  //     subTitle: 'от Кремля',
  //     days: 'Через 7 дней',
  //   )
  // ];
  int itemIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        content(),
      ],
    );
  }

  Widget content() {
    TextStyle style1 = TextStyle(
        color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15.sp);

    TextStyle style2 = TextStyle(
        color: Colors.black, fontWeight: FontWeight.w800, fontSize: 25.sp);

    TextStyle style3 = TextStyle(
        color: ColorStyles.greyColor,
        fontWeight: FontWeight.w700,
        fontSize: 15.sp);

    TextStyle style4 = TextStyle(
        color: ColorStyles.redColor,
        fontWeight: FontWeight.w800,
        fontSize: 25.sp);

    TextStyle style5 = TextStyle(
        color: ColorStyles.accentColor,
        fontWeight: FontWeight.w800,
        fontSize: 15.sp);

    TextStyle style6 = TextStyle(
        color: Colors.black, fontWeight: FontWeight.w800, fontSize: 50.sp);
    
    EventsBloc eventsBloc = context.read<EventsBloc>();

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(color: ColorStyles.backgroundColorGrey),
          Padding(
            padding: EdgeInsets.only(top: 59.h, left: 15.w, right: 15.w),
            child: Row(
              children: [
                SizedBox(
                  width: 55.h,
                  height: 55.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(SvgImg.calendar),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    widget.nextPage();
                  },
                  behavior: HitTestBehavior.translucent,
                  child: SizedBox(
                    width: 55.h,
                    height: 55.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 5.57.h,
                          width: 27.86.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (BuildContext context, index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: index == 0 ? 0 : 5.57.w),
                                height: 5.57.h,
                                width: 5.57.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1.5.r),
                                  color: ColorStyles.greyColor,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 37.h),
          SizedBox(
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
                    );
                  }),
                );
              },
              itemCount: hashTags.length,
            ),
          ),
          SizedBox(height: 38.h),
          BlocConsumer<EventsBloc, EventsState>(
            listener: (context, state) {
              if(state is EventErrorState){
                showAlertToast(state.message);
              }
              if(state is EventInternetErrorState){
                showAlertToast('Проверьте соединение с интернетом!');
              }
            },
            builder: (context, state) {
              if(state is EventLoadingState){
                return Container();
              }
              List<EventEntity> eventsSlider = eventsBloc.events.where((element) 
                        => int.parse(element.datetimeString) < 7).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 25, bottom: 10),
                    child: Text(
                      'Совсем скоро',
                      style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          fontSize: 25),
                    ),
                  ),
                  CarouselSlider.builder(
                      itemCount: eventsSlider.length,
                      itemBuilder: ((context, index, i) {
                        return Padding(
                          padding: EdgeInsets.only(left: i == 0 ? 0 : 20.w),
                          child: CupertinoCard(
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            radius: BorderRadius.circular(40.r),
                            color: Colors.white,
                            child: Container(
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(20.r),
                              //   color: Colors.white,
                              // ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 11.h),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        DayTextWidget(
                                          eventEntity: eventsSlider[i],
                                          additionString: ':',
                                          textStyle: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 25.sp,
                                            fontWeight: FontWeight.w800,
                                            color: getColorFromDays(eventsSlider[i].datetimeString),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width:
                                                  (MediaQuery.of(context).size.width *
                                                          70) /
                                                      100,
                                              child: Text(
                                                eventsSlider[i].title,
                                                style: style6.copyWith(height: 1.1),
                                                softWrap: false,
                                                maxLines: 1,
                                                overflow: TextOverflow.fade,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          setState(() {
                            itemIndex = index;
                          });
                        },
                        viewportFraction: 0.9,
                        height: 113.h,
                        enableInfiniteScroll: false,
                      )),
                  SizedBox(height: 22.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 7.sp,
                        width: 31,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: eventsSlider.length,
                          itemBuilder: (BuildContext context, index) {
                            return Container(
                              margin: EdgeInsets.only(left: index == 0 ? 0 : 5.w),
                              height: 7.sp,
                              width: 7.sp,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.r),
                                border: Border.all(
                                    color: ColorStyles.greyColor, width: 1.5.w),
                                color: index == itemIndex
                                    ? ColorStyles.greyColor
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Container(
                      height: 1,
                      color: ColorStyles.greyColor,
                    ),
                  ),
                  SizedBox(height: 38.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Предстоящие события', style: style2),
                        SizedBox(height: 8.h),
                        Text(countEventsText(eventsBloc.events), style: style3),
                      ],
                    ),
                  ),
                  SizedBox(height: 26.h),
                  events(eventsBloc.events),
                ],
              );
            }
          ),
          
          SizedBox(height: 35.h),
          GestureDetector(
            onTap: () => showModalCreateEvent(
              context,
              (){
                Navigator.pop(context);
              }
            ),
            child: button(),
          ),
          SizedBox(height: 117.h),
        ],
      ),
    );
  }

  Widget events(List<EventEntity> events) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Column(children: eventsItem(events)),
    );
  }

  List<Widget> eventsItem(List<EventEntity> events) {
    List<Widget> list = [];
    for (int i = 0; i < events.length; i++) {
      list.add(itemEvent(events[i]));
    }
    return list;
  }

  Widget itemEvent(EventEntity eventEntity) {
    TextStyle style1 = TextStyle(
        color: Colors.black, fontWeight: FontWeight.w800, fontSize: 20.sp);
    TextStyle style2 = TextStyle(
        color: ColorStyles.greyColor,
        fontWeight: FontWeight.w700,
        fontSize: 15.sp);

    Color? colorDays = checkColor(eventEntity.datetimeString);

    TextStyle style3 = TextStyle(
        color: colorDays, fontWeight: FontWeight.w800, fontSize: 15.sp);

    TextStyle style4 = TextStyle(
        color: ColorStyles.redColor,
        fontWeight: FontWeight.w800,
        fontSize: 15.sp);

    return Padding(
      padding:
          EdgeInsets.only(bottom: 20.h),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(eventEntity.title, style: style1),
              // info.subTitle.contains('Beloved')
              //     ? RichText(
              //         text: TextSpan(children: [
              //           TextSpan(text: 'от ', style: style2),
              //           TextSpan(text: info.subTitle, style: style4),
              //         ]),
              //       )
              //     : 
                  RichText(
                      text: TextSpan(children: [
                        TextSpan(text: 'Добавил(а): ${eventEntity.eventCreator.username}', style: style2),
                      ]),
                    )
            ],
          ),
          const Spacer(),
          DayTextWidget(eventEntity: eventEntity)
        ],
      ),
    );
  }

  Widget button() {
    TextStyle style = TextStyle(
        color: ColorStyles.greyColor,
        fontWeight: FontWeight.w800,
        fontSize: 20.sp);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 55.h,
            decoration: BoxDecoration(
              border: Border.all(color: ColorStyles.accentColor),
              color: ColorStyles.accentColor,
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Text('Новое событие', style: style.copyWith(color: Colors.white))),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 55.h,
              width: 55.w,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 17.h),
                child: SvgPicture.asset(
                  SvgImg.addNewEvent,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color checkColor(String value) {
    Color? colorDays;

    if (value.contains('Сегодня') ||
        value.contains('Завтра') ||
        value.contains('2')) {
      colorDays = const Color.fromRGBO(255, 29, 29, 1);
    } else if (value.contains('3')) {
      colorDays = const Color.fromRGBO(191, 51, 85, 1);
    } else if (value.contains('4')) {
      colorDays = const Color.fromRGBO(128, 74, 142, 1);
    } else if (value.contains('5')) {
      colorDays = const Color.fromRGBO(64, 97, 199, 1);
    } else if (value.contains('6')) {
      colorDays = const Color.fromRGBO(1, 119, 255, 1);
    } else {
      colorDays = const Color.fromRGBO(150, 150, 150, 1);
    }
    return colorDays;
  }
}
