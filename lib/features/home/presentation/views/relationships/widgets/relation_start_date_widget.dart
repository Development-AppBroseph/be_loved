import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/create_event_widget.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/calendar_just_item.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/calendar_selected_item.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/years_month_select_old_widget.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class RelationStartDateWidget extends StatelessWidget {
  final Function() onTapStats;
  final Function() onTapEditDate;
  final Function(DateTime date) onChangeDate;
  DateTime datetime;
  RelationStartDateWidget(
      {super.key, required this.datetime,
      required this.onTapEditDate,
      required this.onChangeDate,
      required this.onTapStats});

  final CustomPopupMenuController _customPopupMenuController =
      CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 243.h,
      child: CupertinoCard(
        radius: BorderRadius.circular(40.r),
        color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
        elevation: 0,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.only(top: 10.h, left: 25.w, right: 25.w),
        child: ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Text(
              'Вы начали встречаться:',
              style: TextStyle(
                  color: const Color(0xFF969696),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 9.h,
            ),
            Row(
              children: [
                Text(
                  DateFormat('dd MMMM', 'RU').format(datetime),
                  style: TextStyle(
                      color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  DateFormat('yyyy', 'RU').format(datetime),
                  style: TextStyle(
                      color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(
              height: (8.h),
            ),
            Container(
              width: 328.w,
              height: 1.h,
              color: const Color(0xFF969696),
            ),
            SizedBox(
              height: 24.h,
            ),
            GestureDetector(
              onTap: onTapStats,
              behavior: HitTestBehavior.translucent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        SvgImg.homeStats,
                        width: 38.w,
                      ),
                      SizedBox(
                        width: 22.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Статистика',
                            style: TextStyle(
                                color: ClrStyle
                                    .black17ToWhite[sl<AuthConfig>().idx],
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            'Посмотреть',
                            style: TextStyle(
                                color: const Color(0xFF969696),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 17.w),
                    child: SvgPicture.asset(
                      SvgImg.homeArrow,
                      height: 20.h,
                      color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomPopupMenu(
              position: PreferredPosition.bottom,
              barrierColor: Colors.transparent,
              showArrow: false,
              controller: _customPopupMenuController,
              menuOnChange: (p) {
                if (!p) {
                  onChangeDate(datetime);
                }
              },
              pressType: PressType.singleClick,
              menuBuilder: () {
                onTapEditDate();
                return _buildDatePicker(
                  context,
                  (date, hide) {
                    if (hide) {
                      _customPopupMenuController.hideMenu();
                    }
                    // setState(() {
                    //   toDate = date;
                    // });
                    // onChangeDate(date);
                    sl<AuthConfig>().user?.date = date.toString();
                    datetime = date;
                  },
                  datetime,
                  fromDate: null,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 5.w,
                      ),
                      SvgPicture.asset(
                        SvgImg.calendar,
                        width: 29.w,
                        color: ColorStyles.redColor,
                      ),
                      SizedBox(
                        width: 26.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Редактировать дату',
                            style: TextStyle(
                                color: ClrStyle
                                    .black17ToWhite[sl<AuthConfig>().idx],
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Text(
                            'Редактировать',
                            style: TextStyle(
                                color: const Color(0xFF969696),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 17.w),
                    child: SvgPicture.asset(
                      SvgImg.homeArrow,
                      height: 20.h,
                      color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildDatePicker(BuildContext context,
    Function(DateTime dateTime, bool hideMenu) onTap, DateTime selectedDay,
    {DateTime? fromDate}) {
  DateTime now = DateTime.now();
  DateTime startDate = DateTime(now.year - 22, now.month, now.day);
  TextStyle style1 = TextStyle(
      color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.w800);

  DateTime focusedDay = DateTime(selectedDay.year, selectedDay.month, 1);
  DateTime calendarStartDay = DateTime(selectedDay.year, selectedDay.month, 1);
  Widget _buildJustDay(context, DateTime date, events) {
    return CalendarJustItem(
        text: date.day.toString(),
        disabled: focusedDay.month != date.month ||
            (fromDate != null &&
                date.millisecondsSinceEpoch <
                    startDate.millisecondsSinceEpoch) ||
            date.millisecondsSinceEpoch < startDate.millisecondsSinceEpoch);
  }

  final kToday = DateTime(startDate.year, startDate.month, 1);
  final kFirstDay = DateTime(kToday.year - 22, kToday.month, kToday.day);
  final kLastDay = now;
  Widget _buildSelectedDay(context, date, events) {
    return CalendarSelectedItem(text: date.day.toString());
  }

  PageController pageController = PageController();

  CalendarType calendarType = CalendarType.days;

  return StatefulBuilder(builder: (context, setState) {
    return Container(
        width: 344.w,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
                blurRadius: 20.h, color: const Color.fromRGBO(0, 0, 0, 0.1))
          ],
        ),
        // padding: EdgeInsets.fromLTRB(25.w, 37.h, 25.w, 30.h),
        child: CupertinoCard(
          padding: EdgeInsets.fromLTRB(25.w, 37.h, 25.w, 30.h),
          color: Colors.white,
          elevation: 0,
          radius: BorderRadius.circular(40.r),
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          if (calendarType == CalendarType.days) {
                            pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOutQuint);
                          }
                        },
                        behavior: HitTestBehavior.opaque,
                        child: SvgPicture.asset(
                          SvgImg.calendarLeftIcon,
                          height: 17.h,
                        )),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (calendarType == CalendarType.days) {
                            calendarType = CalendarType.month;
                          } else if (calendarType == CalendarType.month) {
                            calendarType = CalendarType.years;
                          }
                        });
                      },
                      child: Text(
                        DateFormat(
                                calendarType == CalendarType.days
                                    ? 'MMMM yyyy'
                                    : 'yyyy',
                                'RU')
                            .format(focusedDay)
                            .capitalize(),
                        style: style1,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (calendarType == CalendarType.days) {
                          pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOutQuint);
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: SvgPicture.asset(
                        SvgImg.calendarRightIcon,
                        height: 17.h,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 11.h,
              ),
              if (calendarType != CalendarType.days)
                SizedBox(
                  width: 279.w,
                  child: YearsMonthSelectOldWidget(
                    onTap: (i) {
                      setState(() {
                        if (calendarType == CalendarType.years) {
                          focusedDay =
                              DateTime(i, selectedDay.month, selectedDay.day);
                          calendarType = CalendarType.month;
                          if (focusedDay.millisecondsSinceEpoch >
                              now.millisecondsSinceEpoch) {
                            focusedDay = now;
                          }
                        } else {
                          if (!((i + 1) < startDate.month &&
                              selectedDay.year == startDate.year)) {
                            focusedDay = DateTime(
                                selectedDay.year, i + 1, selectedDay.day);
                            calendarType = CalendarType.days;

                            if (focusedDay.millisecondsSinceEpoch >
                                now.millisecondsSinceEpoch) {
                              focusedDay = now;
                            }
                          }
                        }
                        if (focusedDay.millisecondsSinceEpoch >
                            startDate.millisecondsSinceEpoch) {
                          selectedDay = focusedDay;
                          onTap(focusedDay, false);
                        } else {
                          selectedDay = startDate.add(const Duration(days: 1));
                          onTap(selectedDay, false);
                        }
                        calendarStartDay = focusedDay;
                      });
                    },
                    calendarType: calendarType,
                    focusedDay: focusedDay,
                  ),
                ),
              if (calendarType == CalendarType.days)
                TableCalendar(
                  onCalendarCreated: (con) {
                    pageController = con;
                  },
                  onPageChanged: (dt) {
                    setState(() {
                      focusedDay = dt;
                    });
                    Future.delayed(const Duration(milliseconds: 300), () {
                      setState(() {
                        calendarStartDay = dt;
                      });
                    });
                  },
                  focusedDay: focusedDay,
                  calendarFormat: CalendarFormat.month,
                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  headerVisible: false,
                  pageAnimationCurve: Curves.easeInOutQuint,
                  daysOfWeekVisible: false,
                  rangeSelectionMode: RangeSelectionMode.toggledOff,
                  onDaySelected: (date, events) {
                    if (date.millisecondsSinceEpoch >=
                        startDate.millisecondsSinceEpoch) {
                      onTap(date, false);
                      setState(() {
                        selectedDay = date;
                      });
                    }
                  },
                  rowHeight: 40.h,
                  selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: _buildSelectedDay,
                    defaultBuilder: _buildJustDay,
                    disabledBuilder: _buildJustDay,
                    holidayBuilder: _buildJustDay,
                    outsideBuilder: _buildJustDay,
                    todayBuilder: _buildJustDay,
                  ),
                ),
            ],
          ),
        ));
  });
}
