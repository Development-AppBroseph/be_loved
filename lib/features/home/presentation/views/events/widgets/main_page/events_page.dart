import 'dart:async';
import 'dart:math';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/helpers/date_time_helper.dart';
import 'package:be_loved/core/utils/helpers/events_helper.dart';
import 'package:be_loved/core/utils/helpers/truncate_text_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/buttons/new_event_btn.dart';
import 'package:be_loved/core/widgets/texts/day_text_widget.dart';
import 'package:be_loved/core/widgets/texts/important_text_widget.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/add_events_bottomsheet.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/main_page/widgets/events_list_widget.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/tags_list_block.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/create_event_modal.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ships_page.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;

import '../../../../../data/models/home/hashTag.dart';

class MainEventsPage extends StatefulWidget {
  final VoidCallback nextPage;
  final Function(int id) toDetailPage;
  const MainEventsPage(
      {Key? key, required this.nextPage, required this.toDetailPage})
      : super(key: key);

  @override
  State<MainEventsPage> createState() => _MainEventsPageState();
}

class _MainEventsPageState extends State<MainEventsPage>
    with SingleTickerProviderStateMixin {
  List<HashTagData> hashTags = [
    HashTagData(title: 'Важно', type: TypeHashTag.main),
    HashTagData(title: 'Арбуз', type: TypeHashTag.user),
    HashTagData(title: 'Название', type: TypeHashTag.custom),
    HashTagData(type: TypeHashTag.add),
  ];

  static const _indicatorSize = 30.0;
  static const _imageSize = 30.0;

  final ScrollController scrollController = ScrollController();

  final StreamController<bool> streamController = StreamController();
  bool isLoading = false;
  bool isOpacity = false;

  late AnimationController _spoonController;
  static final _spoonTween = CurveTween(curve: Curves.easeInOutQuint);
  @override
  void initState() {
    _spoonController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    scrollController.addListener(() {
      if (scrollController.offset.toInt() < -40 && !isLoading) {
        _showLoader();
      }
      // print('offset: ' + scrollController.offset.toString());
    });
    super.initState();
  }

  void _showLoader() {
    setState(() {
      isLoading = true;
    });
    streamController.sink.add(true);
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOutQuint,
    );
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isOpacity = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        isOpacity = false;
      });
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      isLoading = false;
      streamController.sink.add(false);
    });
  }

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
        StreamBuilder<bool>(
          stream: streamController.stream,
          initialData: false,
          builder: (context, snapshot) {
            print('Изменения');
            if (snapshot.data!) {
              return Stack(
                children: [
                  backdropFilterExample(
                    context,
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      // color: Colors.black,
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOutQuint,
                    top: isOpacity ? 80.h : -100,
                    left: MediaQuery.of(context).size.width / 2 - 20.w,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 40.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        padding: EdgeInsets.all(10.h),
                        child: Image.asset(
                          'assets/images/smile.png',
                          fit: BoxFit.contain,
                          height: _imageSize,
                        ),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Container(
                width: 0,
                height: 0,
              );
            }
          },
        )
      ],
    );
  }

  Widget _buildImage(IndicatorController controller, ParalaxConfig asset) {
    return Transform.translate(
      offset: Offset(
        0,
        (2 * (controller.value * 30.clamp(1, 10) - 5) * 6) + 30.h,
      ),
      child: OverflowBox(
        maxHeight: 50.h,
        minHeight: 50.h,
        child: Container(
          height: 50.h,
          width: 50.h,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!,
                  offset: Offset(0, 0),
                  blurRadius: 4,
                )
              ]),
          padding: EdgeInsets.all(10.h),
          child: Image.asset(
            'assets/images/smile.png',
            fit: BoxFit.contain,
            height: _imageSize,
          ),
        ),
      ),
    );
  }

  Widget content() {
    TextStyle style1 = TextStyle(
        color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15.sp);

    TextStyle style2 = TextStyle(
        color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
        fontWeight: FontWeight.w700,
        fontSize: 20.sp);

    TextStyle style3 = TextStyle(
        color: ColorStyles.greyColor,
        fontWeight: FontWeight.w700,
        fontSize: 15.sp);

    TextStyle style6 = TextStyle(
        color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
        fontWeight: FontWeight.w800,
        fontSize: 50.sp);

    EventsBloc eventsBloc = context.read<EventsBloc>();

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(color: ColorStyles.backgroundColorGrey),
                Padding(
                  padding: EdgeInsets.only(top: 59.h, left: 15.w, right: 15.w),
                  child: Row(
                    children: [
                      // SizedBox(
                      //   width: 55.h,
                      //   height: 55.h,
                      //   child: Stack(
                      //     alignmСобытияent: Alignment.center,
                      //     children: [
                      //       SvgPicture.asset(SvgImg.calendar),
                      //     ],
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: Text(
                          'События',
                          style: TextStyles(context).black_25_w800,
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
                                        borderRadius:
                                            BorderRadius.circular(1.5.r),
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
                BlocConsumer<EventsBloc, EventsState>(
                  listener: (context, state) {
                    if (state is EventErrorState) {
                      showAlertToast(state.message);
                    }
                    if (state is EventInternetErrorState) {
                      showAlertToast('Проверьте соединение с интернетом!');
                    }
                  },
                  builder: ((context, state) {
                    if (state is EventLoadingState) {
                      return Container();
                    }
                    List<EventEntity> eventsSlider = eventsBloc.events
                        .where(
                            (element) => int.parse(element.datetimeString) < 7)
                        .toList();
                    if (eventsSlider.length > 3) {
                      eventsSlider = [
                        eventsSlider[0],
                        eventsSlider[2],
                        eventsSlider[3]
                      ];
                    }
                    if (eventsSlider.isEmpty) {
                      return Container();
                    }
                    return Column(
                      children: [
                        SizedBox(height: 37.h),
                        CarouselSlider.builder(
                            itemCount: eventsSlider.length,
                            itemBuilder: ((context, index, i) {
                              return Padding(
                                padding:
                                    EdgeInsets.only(left: i == 0 ? 0 : 20.w),
                                child: CupertinoCard(
                                  elevation: 0,
                                  margin: EdgeInsets.zero,
                                  radius: BorderRadius.circular(40.r),
                                  color: ColorStyles.greyColor,
                                  child: SizedBox(
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: CupertinoCard(
                                            elevation: 0,
                                            radius: BorderRadius.circular(37.r),
                                            margin: EdgeInsets.all(1.w),
                                            color: ClrStyle.whiteTo17[
                                                sl<AuthConfig>().idx],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 11.h),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  DayTextWidget(
                                                    eventEntity:
                                                        eventsSlider[i],
                                                    additionString: ':',
                                                    textStyle: TextStyle(
                                                      fontFamily: 'Inter',
                                                      fontSize: 25.sp,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: getColorFromDays(
                                                          eventsSlider[i]
                                                              .datetimeString,
                                                          eventsSlider[i]
                                                              .important),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                70) /
                                                            100,
                                                        child: Text(
                                                          eventsSlider[i].title,
                                                          style:
                                                              style6.copyWith(
                                                                  height: 1.1),
                                                          softWrap: false,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: eventsSlider
                                      .map((e) => Container(
                                            margin: EdgeInsets.only(
                                                left:
                                                    eventsSlider.indexOf(e) == 0
                                                        ? 0
                                                        : 5.w),
                                            height: 7.sp,
                                            width: 7.sp,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2.r),
                                              border: Border.all(
                                                  color: ColorStyles.greyColor,
                                                  width: 1.5.w),
                                              color: eventsSlider.indexOf(e) ==
                                                      itemIndex
                                                  ? ColorStyles.greyColor
                                                  : null,
                                            ),
                                          ))
                                      .toList(),
                                )),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
                SizedBox(height: 45.h),
                TagsListBlock(
                  isBlack2C: true,
                ),
                SizedBox(height: 25.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: GestureDetector(
                    onTap: () {
                      widget.nextPage();
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Предстоящие события', style: style2),
                            SizedBox(height: 8.h),
                            Text(countEventsText(eventsBloc.eventsSorted),
                                style: style3),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 45.w,
                          width: 45.w,
                          child: Stack(
                            children: [
                              Align(
                                child: Transform.rotate(
                                    angle: pi,
                                    child: SvgPicture.asset(
                                      SvgImg.back,
                                      height: 20.41.h,
                                      width: 11.37.h,
                                      color: ClrStyle
                                          .black17ToWhite[sl<AuthConfig>().idx],
                                    )),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 17.h),
                BlocConsumer<EventsBloc, EventsState>(
                    listener: (context, state) {
                  if (state is EventErrorState) {
                    showAlertToast(state.message);
                  }
                  if (state is EventInternetErrorState) {
                    showAlertToast('Проверьте соединение с интернетом!');
                  }
                  if (state is EventAddedState ||
                      state is GotSuccessEventsState) {
                    setState(() {});
                  }
                }, builder: (context, state) {
                  if (state is EventLoadingState) {
                    return Container();
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: Container(
                          height: 1,
                          color: ColorStyles.greyColor,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      EventsListWidget(
                          events: eventsBloc.eventsSorted,
                          onTap: (id) {
                            widget.toDetailPage(id);
                          })
                    ],
                  );
                }),
                SizedBox(height: 35.h),
                NewEventBtn(
                  onTap: () => showModalCreateEvent(context, () {
                    Navigator.pop(context);
                  }),
                  isActive: !(eventsBloc.events.length >= 30),
                ),
                SizedBox(
                  height: 350.h,
                  width: 100.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget backdropFilterExample(BuildContext context, Widget child) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        child,
        AnimatedOpacity(
          opacity: isOpacity ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Container(
              color: const Color.fromRGBO(44, 44, 46, 0.1),
            ),
          ),
        )
      ],
    );
  }
}
