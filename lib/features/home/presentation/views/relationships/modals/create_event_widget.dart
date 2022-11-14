import 'dart:async';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/bloc/relation_ships/events_bloc.dart';
import 'package:be_loved/core/utils/helpers/events.dart';
import 'package:be_loved/core/utils/helpers/time_text.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/core/widgets/text_fields/default_text_form_field.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/calendar_just_item.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/calendar_selected_item.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/time_item_text_field_widget.dart';
import 'package:be_loved/core/widgets/buttons/switch_btn.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/time_item_widget.dart';
import '../widgets/years_month_select_widget.dart';
import 'icon_select_modal.dart';

class CreateEventWidget extends StatefulWidget {
  final Function() onTap;
  const CreateEventWidget({Key? key, required this.onTap}) : super(key: key);
  @override
  State<CreateEventWidget> createState() => _CreateEventWidgetState();
}

class _CreateEventWidgetState extends State<CreateEventWidget> {
  GlobalKey iconBtn = GlobalKey();
  TextStyle style1 = TextStyle(
      color: ColorStyles.greyColor,
      fontSize: 15.sp,
      fontWeight: FontWeight.w800);
  TextStyle style2 = TextStyle(
      color: ColorStyles.blackColor,
      fontSize: 18.sp,
      fontWeight: FontWeight.w800);

  TextStyle styleBtn = TextStyle(
      color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w700);

  bool switchVal1 = false;
  bool switchVal2 = false;
  bool switchVal3 = false;
  int iconIndex = 15;
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerFromTime = TextEditingController();
  final TextEditingController _controllerToTime = TextEditingController();

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(const Duration(days: 5));
  final ScrollController scrollController = ScrollController();

  final CustomPopupMenuController _customPopupMenuController1 =
      CustomPopupMenuController();
  final CustomPopupMenuController _customPopupMenuController2 =
      CustomPopupMenuController();
  final CustomPopupMenuController _customPopupMenuControllerIcon =
      CustomPopupMenuController();

  validateTextFields() {
    setState(() {
      timeTextHelper(_controllerFromTime.text)
          ? {}
          : _controllerFromTime.clear();
      timeTextHelper(_controllerToTime.text) ? {} : _controllerToTime.clear();
    });
  }

  bool isValidate() {
    return _controllerName.text.length > 3 &&
        _controllerDescription.text.length > 3 &&
        _controllerFromTime.text.length > 3 &&
        _controllerToTime.text.length > 3;
  }

  bool keyboardOpened = false;
  late StreamSubscription<bool> keyboardSub;

  showIconModal() async {
    await scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOutQuint);
    iconSelectModal(context, getWidgetPosition(iconBtn), (index) {
      setState(() {
        iconIndex = index;
      });
      Navigator.pop(context);
    }, iconIndex);
  }

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
        setState(() {});
      },
      child: CupertinoCard(
        radius: BorderRadius.vertical(
          top: Radius.circular(80.r),
        ),
        elevation: 0,
        margin: EdgeInsets.zero,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutQuint,
            height: MediaQuery.of(context).size.height *
                    (keyboardOpened ? 0.99 : 0.8) -
                (keyboardOpened ? MediaQuery.of(context).padding.top : 0),
            width: MediaQuery.of(context).size.width,
            color: const Color.fromRGBO(0, 0, 0, 0),
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
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
                            maxLength: 40,
                            hideCounter: true,
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          DefaultTextFormField(
                              hint: 'Описание',
                              maxLines: 3,
                              controller: _controllerDescription,
                              maxLength: 50,
                              onChange: (s) {
                                setState(() {});
                              }),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: ColorStyles.backgroundColorGrey),
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 12.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                  color: ColorStyles.greyColor,
                                  width: MediaQuery.of(context).size.width,
                                  height: 1.h,
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Начало',
                                      style: style2,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CustomPopupMenu(
                                            position: PreferredPosition.bottom,
                                            barrierColor: Colors.transparent,
                                            showArrow: false,
                                            controller:
                                                _customPopupMenuController1,
                                            pressType: PressType.singleClick,
                                            menuBuilder: () {
                                              return _buildDatePicker(context,
                                                  (date, hide) {
                                                if (hide) {
                                                  _customPopupMenuController1
                                                      .hideMenu();
                                                }
                                                setState(() {
                                                  fromDate = date;
                                                  if (fromDate
                                                          .millisecondsSinceEpoch >
                                                      toDate
                                                          .millisecondsSinceEpoch) {
                                                    toDate = fromDate.add(
                                                        const Duration(
                                                            days: 1));
                                                  }
                                                });
                                              }, fromDate);
                                            },
                                            child: TimeItemWidget(
                                                text: DateFormat(
                                                        'd MMM yyyy г.', 'RU')
                                                    .format(fromDate))),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        TimeItemTextFieldWidget(
                                          controller: _controllerFromTime,
                                          validateText: validateTextFields,
                                          onChanged: (text) {
                                            if (text != null &&
                                                text.isNotEmpty) {
                                              if (text.length == 2 &&
                                                  int.parse(text[0]) == 2 &&
                                                  int.parse(text[1]) > 3) {
                                                _controllerFromTime.text = '';
                                                setState(() {});
                                              }
                                            }
                                          },
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Конец',
                                      style: style2,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CustomPopupMenu(
                                            position: PreferredPosition.bottom,
                                            barrierColor: Colors.transparent,
                                            showArrow: false,
                                            controller:
                                                _customPopupMenuController2,
                                            pressType: PressType.singleClick,
                                            menuBuilder: () {
                                              return _buildDatePicker(context,
                                                  (date, hide) {
                                                if (hide) {
                                                  _customPopupMenuController2
                                                      .hideMenu();
                                                }
                                                setState(() {
                                                  toDate = date;
                                                });
                                              }, toDate, fromDate: fromDate);
                                            },
                                            child: TimeItemWidget(
                                                text: DateFormat(
                                                        'd MMM yyyy г.', 'RU')
                                                    .format(toDate))),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        TimeItemTextFieldWidget(
                                          controller: _controllerToTime,
                                          validateText: validateTextFields,
                                          onChanged: (text) {
                                            if (text != null &&
                                                text.isNotEmpty) {
                                              if (text.length == 2 &&
                                                  int.parse(text[0]) == 2 &&
                                                  int.parse(text[1]) > 3) {
                                                _controllerToTime.text = '';
                                                setState(() {});
                                              }
                                            }
                                          },
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
                                color: ColorStyles.backgroundColorGrey),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 13.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                color: ColorStyles.backgroundColorGrey),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 13.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            height: 57.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.r),
                                color: ColorStyles.backgroundColorGrey),
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Иконка',
                                  style: style2,
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: showIconModal,
                                    onPanEnd: (d) {
                                      showIconModal();
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Row(
                                      children: [
                                        iconIndex == 15
                                            ? SvgPicture.asset(
                                                'assets/icons/no_icon.svg',
                                                height: 28.h,
                                                key: iconBtn,
                                              )
                                            : Text(
                                                '😎',
                                                key: iconBtn,
                                                style:
                                                    TextStyle(fontSize: 30.sp),
                                              ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        SvgPicture.asset(
                                          SvgImg.upDownIcon,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 60.h,
                                child: CustomButton(
                                  color: ColorStyles.redColor,
                                  text: 'Создать событие',
                                  validate: true,
                                  code: false,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  svg: 'assets/icons/close_event_create.svg',
                                  svgHeight: 22.h,
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: CustomButton(
                                  color: ColorStyles.accentColor,
                                  text: 'Создать событие',
                                  validate: isValidate(),
                                  code: false,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    if (isValidate()) {
                                      // BlocProvider.of<EventsBloc>(context)
                                      //     .add(AddEvent(
                                      //         events: Events(
                                      //   name: _controllerName.text,
                                      //   description: _controllerDescription.text,
                                      //   datetime: DateTime.fromMillisecondsSinceEpoch(fromDate.millisecond - DateTime.now().millisecond).day.toString(),
                                      // )));
                                      widget.onTap();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height:
                                74.h + MediaQuery.of(context).padding.bottom,
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                color: ColorStyles.greyColor,
                              ),
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
      ),
    );
  }
}

Widget _buildDatePicker(BuildContext context,
    Function(DateTime dateTime, bool hideMenu) onTap, DateTime selectedDay,
    {DateTime? fromDate}) {
  DateTime currentDate = fromDate != null ? fromDate : DateTime.now();
  TextStyle style1 = TextStyle(
      color: Colors.black, fontSize: 20.sp, fontWeight: FontWeight.w800);
  TextStyle style2 = TextStyle(
      color: ColorStyles.blackColor,
      fontSize: 18.sp,
      fontWeight: FontWeight.w700);
  DateTime _focusedDay = DateTime(selectedDay.year, selectedDay.month, 1);
  DateTime _calendarStartDay = DateTime(selectedDay.year, selectedDay.month, 1);
  Widget _buildJustDay(context, DateTime date, events) {
    return CalendarJustItem(
        text: date.day.toString(),
        disabled: _focusedDay.month != date.month ||
            (fromDate != null &&
                date.millisecondsSinceEpoch <
                    currentDate.millisecondsSinceEpoch) ||
            date.millisecondsSinceEpoch < currentDate.millisecondsSinceEpoch);
  }

  final kToday = DateTime(currentDate.year, currentDate.month, 1);
  final kFirstDay = kToday;
  final kLastDay = DateTime(kToday.year + 13, kToday.month, kToday.day);
  Widget _buildSelectedDay(context, date, events) {
    return CalendarSelectedItem(text: date.day.toString());
  }

  PageController _pageController = PageController();

  CalendarType _calendarType = CalendarType.days;

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
                          if (_calendarType == CalendarType.days) {
                            _pageController.previousPage(
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
                          if (_calendarType == CalendarType.days) {
                            _calendarType = CalendarType.month;
                          } else if (_calendarType == CalendarType.month) {
                            _calendarType = CalendarType.years;
                          }
                        });
                      },
                      child: Text(
                        DateFormat(
                                _calendarType == CalendarType.days
                                    ? 'MMMM yyyy'
                                    : 'yyyy',
                                'RU')
                            .format(_focusedDay)
                            .capitalize(),
                        style: style1,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_calendarType == CalendarType.days) {
                          _pageController.nextPage(
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
              if (_calendarType != CalendarType.days)
                SizedBox(
                  width: 279.w,
                  child: YearsMonthSelectWidget(
                    onTap: (i) {
                      setState(() {
                        if (_calendarType == CalendarType.years) {
                          _focusedDay =
                              DateTime(i, selectedDay.month, selectedDay.day);
                          _calendarType = CalendarType.month;
                        } else {
                          if (!((i + 1) < currentDate.month &&
                              selectedDay.year == currentDate.year)) {
                            _focusedDay = DateTime(
                                selectedDay.year, i + 1, selectedDay.day);
                            _calendarType = CalendarType.days;
                          }
                        }
                        if (_focusedDay.millisecondsSinceEpoch >
                            currentDate.millisecondsSinceEpoch) {
                          selectedDay = _focusedDay;
                          onTap(_focusedDay, false);
                        } else {
                          selectedDay =
                              currentDate.add(const Duration(days: 1));
                          onTap(selectedDay, false);
                        }
                        _calendarStartDay = _focusedDay;
                      });
                    },
                    calendarType: _calendarType,
                    focusedDay: _focusedDay,
                  ),
                ),
              if (_calendarType == CalendarType.days)
                TableCalendar(
                  onCalendarCreated: (con) {
                    _pageController = con;
                  },
                  onPageChanged: (dt) {
                    setState(() {
                      _focusedDay = dt;
                    });
                    Future.delayed(const Duration(milliseconds: 300), () {
                      setState(() {
                        _calendarStartDay = dt;
                      });
                    });
                  },
                  focusedDay: _focusedDay,
                  calendarFormat: CalendarFormat.month,

                  firstDay: kFirstDay,
                  lastDay: kLastDay,
                  headerVisible: false,
                  pageAnimationCurve: Curves.easeInOutQuint,
                  daysOfWeekVisible: false,
                  // startingDayOfWeek: _calendarStartDay.year == currentDate.year && _calendarStartDay.month == currentDate.month
                  // ? (kToday.weekday == DateTime.monday
                  // ? StartingDayOfWeek.monday
                  // : kToday.weekday == DateTime.tuesday
                  // ? StartingDayOfWeek.tuesday
                  // : kToday.weekday == DateTime.wednesday
                  // ? StartingDayOfWeek.wednesday
                  // : kToday.weekday == DateTime.thursday
                  // ? StartingDayOfWeek.thursday
                  // : kToday.weekday == DateTime.friday
                  // ? StartingDayOfWeek.friday
                  // : kToday.weekday == DateTime.saturday
                  // ? StartingDayOfWeek.saturday
                  // : StartingDayOfWeek.sunday)
                  // : (_calendarStartDay.weekday == DateTime.monday
                  // ? StartingDayOfWeek.friday
                  // : _calendarStartDay.weekday == DateTime.tuesday
                  // ? StartingDayOfWeek.saturday
                  // : _calendarStartDay.weekday == DateTime.wednesday
                  // ? StartingDayOfWeek.sunday
                  // : _calendarStartDay.weekday == DateTime.thursday
                  // ? StartingDayOfWeek.monday
                  // : _calendarStartDay.weekday == DateTime.friday
                  // ? StartingDayOfWeek.tuesday
                  // : _calendarStartDay.weekday == DateTime.saturday
                  // ? StartingDayOfWeek.wednesday
                  // : StartingDayOfWeek.thursday),
                  rangeSelectionMode: RangeSelectionMode.toggledOff,
                  onDaySelected: (date, events) {
                    if (date.millisecondsSinceEpoch >=
                        currentDate.millisecondsSinceEpoch) {
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

enum CalendarType { days, month, years }

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

Offset getWidgetPosition(GlobalKey key) {
  final RenderBox renderBox =
      key.currentContext?.findRenderObject() as RenderBox;

  return renderBox.localToGlobal(Offset.zero);
}
