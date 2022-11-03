import 'dart:async';

import 'package:be_loved/core/helpers/time_text.dart';
import 'package:be_loved/ui/home/relationships/widgets/calendar_just_item.dart';
import 'package:be_loved/ui/home/relationships/widgets/calendar_selected_item.dart';
import 'package:be_loved/ui/home/relationships/widgets/time_item_text_field_widget.dart';
import 'package:be_loved/widgets/buttons/switch_btn.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../core/helpers/constants.dart';
import '../../../../core/widgets/text_fields/default_text_form_field.dart';
import '../widgets/time_item_widget.dart';
import '../widgets/years_month_select_widget.dart';


class CreateEventWidget extends StatefulWidget {
  final Function() onTap;
  CreateEventWidget({required this.onTap});
  @override
  State<CreateEventWidget> createState() => _CreateEventWidgetState();
}

class _CreateEventWidgetState extends State<CreateEventWidget> {
  TextStyle style1 = TextStyle(
      color: greyColor, fontSize: 15.sp, fontWeight: FontWeight.w800);
  TextStyle style2 = TextStyle(
      color: blackColor, fontSize: 18.sp, fontWeight: FontWeight.w800);

  TextStyle styleBtn = TextStyle(
      color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w700);

  bool switchVal1 = false;
  bool switchVal2 = false;
  bool switchVal3 = false;
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerDescription = TextEditingController();
  TextEditingController _controllerFromTime = TextEditingController();
  TextEditingController _controllerToTime = TextEditingController();

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(Duration(days: 5));
  CustomPopupMenuController _customPopupMenuController1 =
      CustomPopupMenuController();
  CustomPopupMenuController _customPopupMenuController2 =
      CustomPopupMenuController();

  validateTextFields(){
    setState(() {
      timeTextHelper(_controllerFromTime.text) ? {} : _controllerFromTime.clear();
      timeTextHelper(_controllerToTime.text) ? {} : _controllerToTime.clear();
    });
    
  }



  bool keyboardOpened = false;
  late StreamSubscription<bool> keyboardSub;

  @override
  void initState() {
    super.initState();
    keyboardSub = KeyboardVisibilityController().onChange.listen((event) {
      validateTextFields();
      setState(() {
        keyboardOpened = event;
      });
    });
  }

  @override
  void dispose() {
    keyboardSub.cancel();
    // TODO: implement dispose
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOutQuint,
        height: MediaQuery.of(context).size.height * (keyboardOpened ? 0.99 : 0.8) - (keyboardOpened ? MediaQuery.of(context).padding.top : 0),
        width: MediaQuery.of(context).size.width,
        color: Color.fromRGBO(0, 0, 0, 0),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 78.h,
                      ),
                      DefaultTextFormField(
                        hint: 'Название',
                        maxLines: 1,
                        controller: _controllerName,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      DefaultTextFormField(
                        hint: 'Описание',
                        maxLines: 3,
                        onChange: (b) {
                          setState(() {});
                        },
                        controller: _controllerDescription,
                        maxLength: 50,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: backgroundColorGrey),
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 12.h,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Весь день',
                                  style: style2,
                                ),
                                SwitchBtn(
                                    onChange: (val) {
                                      setState(() {
                                        switchVal1 = val;
                                      });
                                    },
                                    value: switchVal1)
                              ],
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Container(
                              color: greyColor,
                              width: MediaQuery.of(context).size.width,
                              height: 1.h,
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Начало',
                                  style: style2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.end,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    CustomPopupMenu(
                                        barrierColor:
                                            Colors.transparent,
                                        showArrow: false,
                                        controller:
                                            _customPopupMenuController1,
                                        pressType:
                                            PressType.singleClick,
                                        menuBuilder: () {
                                          return _buildDatePicker(
                                              context, (date, hide) {
                                            if (hide) {
                                              _customPopupMenuController1
                                                  .hideMenu();
                                            }
                                            setState(() {
                                              fromDate = date;
                                            });
                                          }, fromDate);
                                        },
                                        child: TimeItemWidget(
                                            text: DateFormat(
                                                    'd MMM. yyyy г.')
                                                .format(fromDate))),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    TimeItemTextFieldWidget(
                                      controller: _controllerFromTime,
                                      validateText: validateTextFields,
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Конец',
                                  style: style2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.end,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    CustomPopupMenu(
                                        barrierColor:
                                            Colors.transparent,
                                        showArrow: false,
                                        controller:
                                            _customPopupMenuController2,
                                        pressType:
                                            PressType.singleClick,
                                        menuBuilder: () {
                                          return _buildDatePicker(
                                              context, (date, hide) {
                                            if (hide) {
                                              _customPopupMenuController2
                                                  .hideMenu();
                                            }
                                            setState(() {
                                              toDate = date;
                                            });
                                          }, toDate);
                                        },
                                        child: TimeItemWidget(
                                            text: DateFormat(
                                                    'd MMM. yyyy г.')
                                                .format(toDate))),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    TimeItemTextFieldWidget(
                                      controller: _controllerToTime,
                                      validateText: validateTextFields,
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 32.h,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: backgroundColorGrey),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 13.h),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Повтор',
                              style: style2,
                            ),
                            SwitchBtn(
                                onChange: (val) {
                                  setState(() {
                                    switchVal2 = val;
                                  });
                                },
                                value: switchVal2)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: backgroundColorGrey),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 13.h),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Напоминание',
                              style: style2,
                            ),
                            SwitchBtn(
                                onChange: (val) {
                                  setState(() {
                                    switchVal3 = val;
                                  });
                                },
                                value: switchVal3)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.r),
                            color: backgroundColorGrey),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 13.h),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Иконка',
                              style: style2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '😎',
                                  style: TextStyle(fontSize: 30.sp),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                SvgPicture.asset(
                                  'assets/icons/up_down_icon.svg',
                                  height: 20.h,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: Container(
                              width: 60.h,
                              height: 60.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: redColor,
                                  borderRadius:
                                      BorderRadius.circular(10.r)),
                              child: SvgPicture.asset(
                                'assets/icons/close_event_create.svg',
                                height: 22.h,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: widget.onTap,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                height: 60.h,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(bottom: 2.h),
                                decoration: BoxDecoration(
                                    color: accentColor,
                                    borderRadius:
                                        BorderRadius.circular(10.r)),
                                child: Text(
                                  'Создать событие',
                                  style: styleBtn,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 74.h +
                            MediaQuery.of(context).padding.bottom,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                right: 0,
                left: 0,
                top: 0,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28.h),
                        topRight: Radius.circular(28.h),
                      ),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.fromLTRB(0, 7.h, 0, 18.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 100.w,
                          height: 5.h,
                          color: greyColor,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          'Создать событие',
                          style: style1,
                        )
                      ],
                    )))
          ],
        )),
  );
}
}



Widget _buildDatePicker(BuildContext context,
  Function(DateTime dateTime, bool hideMenu) onTap, DateTime selectedDay) {
DateTime currentDate = DateTime.now();
TextStyle style1 = TextStyle(
    color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.w800);
TextStyle style2 = TextStyle(
    color: blackColor, fontSize: 18.sp, fontWeight: FontWeight.w700);
Widget _buildJustDay(context, DateTime date, events) {
  return CalendarJustItem(
    text: date.day.toString(),
    disabled: date.year > currentDate.year || (date.year == currentDate.year && date.month > currentDate.month)
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 12, kToday.day);
final kLastDay = DateTime(kToday.year + 13, kToday.month, kToday.day);
Widget _buildSelectedDay(context, date, events) {
  return CalendarSelectedItem(text: date.day.toString());
}

DateTime _focusedDay = selectedDay;
PageController _pageController = PageController();

CalendarType _calendarType = CalendarType.days;

return StatefulBuilder(builder: (context, setState) {
  return Container(
      width: 344.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(blurRadius: 20.h, color: Color.fromRGBO(0, 0, 0, 0.1))
        ],
        color: Colors.white,
      ),
      padding: EdgeInsets.fromLTRB(25.w, 37.h, 25.w, 30.h),
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
                      if (_calendarType == CalendarType.days) {
                        _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOutQuint);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: SvgPicture.asset(
                      'assets/icons/calendar_left_icon.svg',
                      height: 17.h,
                    )),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_calendarType == CalendarType.days) {
                        _calendarType = CalendarType.month;
                      } else if (_calendarType == CalendarType.month) {
                        _calendarType = CalendarType.years;
                      }
                    });
                  },
                  child: Text(
                    DateFormat(_calendarType == CalendarType.days
                            ? 'MMMM yyyy'
                            : 'yyyy')
                        .format(_focusedDay),
                    style: style1,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_calendarType == CalendarType.days) {
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOutQuint);
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: SvgPicture.asset(
                    'assets/icons/calendar_right_icon.svg',
                    height: 17.h,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          if (_calendarType != CalendarType.days)
            YearsMonthSelectWidget(
              onTap: (i) {
                setState(() {
                  if (_calendarType == CalendarType.years) {
                    _focusedDay =
                        DateTime(i, _focusedDay.month, _focusedDay.day);
                    _calendarType = CalendarType.month;
                  } else {
                    _focusedDay =
                        DateTime(_focusedDay.year, i + 1, _focusedDay.day);
                    _calendarType = CalendarType.days;
                  }
                  onTap(_focusedDay, false);
                });
              },
              calendarType: _calendarType,
              focusedDay: _focusedDay,
            ),
          if (_calendarType == CalendarType.days)
            TableCalendar(
              onCalendarCreated: (con) {
                _pageController = con;
              },
              onPageChanged: (dt){
                setState((){
                  _focusedDay = dt;
                });
              },
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              
              firstDay: kFirstDay,
              lastDay: kLastDay,
              headerVisible: false,
              pageAnimationCurve: Curves.easeInOutQuint,
              daysOfWeekVisible: false,
              startingDayOfWeek: StartingDayOfWeek.monday,
              rangeSelectionMode: RangeSelectionMode.toggledOff,
              onDaySelected: (date, events) {
                if(date.millisecondsSinceEpoch >= currentDate.millisecondsSinceEpoch){
                  onTap(date, true);
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
      ));
  });
}

enum CalendarType { days, month, years }