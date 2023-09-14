import 'dart:async';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/helpers/time_text.dart';
import 'package:be_loved/core/utils/helpers/widget_position_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/utils/toasts.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/core/widgets/buttons/switch_btn.dart';
import 'package:be_loved/core/widgets/loaders/overlay_loader.dart';
import 'package:be_loved/core/widgets/text_fields/default_text_form_field.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ship_settings_page.dart/widgets/select_repeat.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/calendar_just_item.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/calendar_selected_item.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/time_item_text_field_widget.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widgets/time_item_widget.dart';
import '../widgets/years_month_select_widget.dart';
import 'icon_select_modal.dart';

class CreateEventWidget extends StatefulWidget {
  final Function() onTap;
  final EventEntity? editingEvent;
  const CreateEventWidget(
      {Key? key, required this.onTap, required this.editingEvent})
      : super(key: key);
  @override
  State<CreateEventWidget> createState() => _CreateEventWidgetState();
}

class _CreateEventWidgetState extends State<CreateEventWidget> {
  GlobalKey iconBtn = GlobalKey();
  GlobalKey datePicker = GlobalKey();
  GlobalKey repeatPicker = GlobalKey();
  TextStyle style1 = TextStyle(
      color: ColorStyles.greyColor,
      fontSize: 15.sp,
      fontWeight: FontWeight.w800);
  TextStyle style2 = TextStyle(
      color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
      fontSize: 18.sp,
      fontWeight: FontWeight.w800);

  TextStyle styleBtn = TextStyle(
      color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w700);

  bool allDays = true;
  bool repeat = false;
  bool notification = true;
  List<Map<String, dynamic>> repeats = [
    {
      'repeat': 'Каждый день',
      'interval': 'day',
    },
    {
      'repeat': 'Каждые 3 дня',
      'interval': 'three',
    },
    {
      'repeat': 'Каждую неделю',
      'interval': 'week',
    },
    {'repeat': 'Каждый месяц', 'interval': 'month'},
    {'repeat': 'Каждый год', 'interval': 'year'}
  ];

  int iconIndex = 15;
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerFromTime =
      TextEditingController(text: '23:59');
  final TextEditingController _controllerToTime =
      TextEditingController(text: '23:59');

  final streamRepeat = StreamController<int>();

  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(const Duration(days: 5));
  final ScrollController scrollController = ScrollController();

  final CustomPopupMenuController _customPopupMenuController1 =
      CustomPopupMenuController();
  final CustomPopupMenuController _customPopupMenuController2 =
      CustomPopupMenuController();

  String title = 'Создать событие';
  bool validate = false;

  validateTextFields() {
    setState(() {
      timeTextHelper(_controllerFromTime.text)
          ? {}
          : _controllerFromTime.clear();
      timeTextHelper(_controllerToTime.text) ? {} : _controllerToTime.clear();
    });
  }

  bool fieldValidation(TextEditingController controller) {
    return controller.text.length > 3 && controller.text.trim() != '';
  }

  bool isValidate() {
    return _controllerName.text.length > 3 &&
        (_controllerFromTime.text.length > 3 || allDays) &&
        (_controllerToTime.text.length > 3 || allDays);
  }

  bool keyboardOpened = false;
  late StreamSubscription<bool> keyboardSub;

  showIconModal() async {
    await scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutQuint);
    iconSelectModal(
      context,
      getWidgetPosition(iconBtn),
      (index) {
        setState(() {
          iconIndex = index;
        });
        Navigator.pop(context);
      },
      iconIndex,
    );
  }

  showSelectrorRepeat() async {
    await scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutQuint);
    showSelector(
        context, getWidgetPosition(repeatPicker), repeats, streamRepeat);
  }

  createEvent(AsyncSnapshot<int> snapshot) {
    if (isValidate()) {
      if (context.read<EventsBloc>().events.length >= 30) {
        showAlertToast('Максимум кол-во событии 30');
      }
      showLoaderWrapper(context);
      if (widget.editingEvent != null) {
        context.read<EventsBloc>().add(
              EventEditEvent(
                eventEntity: EventEntity(
                  id: widget.editingEvent!.id,
                  title: _controllerName.text,
                  photo: null,
                  description: _controllerDescription.text,
                  important: false,
                  start: DateTime(
                    fromDate.year,
                    fromDate.month,
                    fromDate.day,
                    _controllerFromTime.text.length > 4
                        ? int.parse(_controllerFromTime.text.split(":")[0])
                        : 0,
                    _controllerFromTime.text.length > 4
                        ? int.parse(_controllerFromTime.text.split(":")[1])
                        : 0,
                  ),
                  finish: DateTime(
                    toDate.year,
                    toDate.month,
                    toDate.day,
                    _controllerToTime.text.length > 4
                        ? int.parse(_controllerToTime.text.split(":")[0])
                        : 0,
                    _controllerToTime.text.length > 4
                        ? int.parse(_controllerToTime.text.split(":")[1])
                        : 0,
                  ),
                  datetimeString: '',
                  tagIds: const [],
                  married: widget.editingEvent!.married,
                  relationId: sl<AuthConfig>().user!.relationId!,
                  notification: notification,
                  repeat: notification,
                  allDays: allDays,
                  eventCreator: sl<AuthConfig>().user!.me,
                  mainPosition: widget.editingEvent!.mainPosition,
                  cycle: repeats[snapshot.data!]['interval'],
                ),
              ),
            );
      } else {
        context.read<EventsBloc>().add(
              EventAddEvent(
                eventEntity: EventEntity(
                  id: 0,
                  title: _controllerName.text,
                  description: _controllerDescription.text,
                  important: false,
                  tagIds: const [],
                  photo: null,
                  start: DateTime(
                      fromDate.year,
                      fromDate.month,
                      fromDate.day,
                      _controllerFromTime.text.length > 4
                          ? int.parse(_controllerFromTime.text.split(":")[0])
                          : 0,
                      _controllerFromTime.text.length > 4
                          ? int.parse(_controllerFromTime.text.split(":")[1])
                          : 0),
                  finish: DateTime(
                      toDate.year,
                      toDate.month,
                      toDate.day,
                      _controllerToTime.text.length > 4
                          ? int.parse(_controllerToTime.text.split(":")[0])
                          : 0,
                      _controllerToTime.text.length > 4
                          ? int.parse(_controllerToTime.text.split(":")[1])
                          : 0),
                  datetimeString: '',
                  married: false,
                  relationId: sl<AuthConfig>().user!.relationId!,
                  notification: notification,
                  repeat: notification,
                  allDays: allDays,
                  eventCreator: sl<AuthConfig>().user!.me,
                  mainPosition: 0,
                  cycle: repeats[snapshot.data!]['interval'],
                ),
              ),
            );
      }
      // if (notification) {
      //   if (snapshot.data! == 3 || snapshot.data! == 4) {
      //     if (snapshot.data! == 3) {
      //       NotificationService().yearsPushNotification(
      //         title: _controllerName.text,
      //         body: _controllerDescription.text,
      //         id: widget.editingEvent != null ? widget.editingEvent!.id : 0,
      //         minute: _controllerFromTime.text.length > 4
      //             ? int.parse(_controllerFromTime.text.split(":")[1])
      //             : 0,
      //         hour: _controllerFromTime.text.length > 4
      //             ? int.parse(_controllerFromTime.text.split(":")[0])
      //             : 0,
      //       );
      //     } else {
      //       NotificationService().monthlyPushNotification(
      //         title: _controllerName.text,
      //         body: _controllerDescription.text,
      //         id: widget.editingEvent != null ? widget.editingEvent!.id : 0,
      //         minute: _controllerFromTime.text.length > 4
      //             ? int.parse(_controllerFromTime.text.split(":")[1])
      //             : 0,
      //         hour: _controllerFromTime.text.length > 4
      //             ? int.parse(_controllerFromTime.text.split(":")[0])
      //             : 0,
      //       );
      //     }
      //   } else {
      //     NotificationService().pushNotification(
      //       title: _controllerName.text,
      //       body: _controllerDescription.text,
      //       id: widget.editingEvent != null ? widget.editingEvent!.id : 0,
      //       minute: _controllerFromTime.text.length > 4
      //           ? int.parse(_controllerFromTime.text.split(":")[1])
      //           : 0,
      //       hour: _controllerFromTime.text.length > 4
      //           ? int.parse(_controllerFromTime.text.split(":")[0])
      //           : 0,
      //     );
      //   }
      // }

      // NotificationService().cancelPushNotification();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.editingEvent != null) {
      EventEntity model = widget.editingEvent!;
      _controllerName.text = model.title;
      _controllerDescription.text = model.description;
      print('TSSS: ${model.start}');
      _controllerFromTime.text = DateFormat('HH:mm').format(model.start);
      _controllerToTime.text = DateFormat('HH:mm').format(model.finish);
      fromDate = model.start;
      toDate = model.finish;
      allDays = model.allDays;
      notification = model.notification;
      repeat = model.repeat;

      title = 'Редактировать событие';
    }
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
    streamRepeat.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: streamRepeat.stream,
        initialData: 0,
        builder: (context, snapshot) {
          return BlocListener<EventsBloc, EventsState>(
            listener: (context, state) {
              if (state is EventErrorState) {
                Loader.hide();
                showAlertToast(state.message);
              }
              if (state is EventInternetErrorState) {
                Loader.hide();
                showAlertToast('Проверьте соединение с интернетом!');
              }
              if (state is EventAddedState) {
                Loader.hide();
                Navigator.pop(context);
              }
            },
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {});
              },
              child: CupertinoCard(
                radius: BorderRadius.vertical(
                  top: Radius.circular(80.r),
                ),
                elevation: 0,
                color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
                margin: EdgeInsets.zero,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutQuint,
                    height: MediaQuery.of(context).size.height *
                            (keyboardOpened ? 0.99 : 0.8) -
                        (keyboardOpened
                            ? MediaQuery.of(context).padding.top
                            : 0),
                    width: MediaQuery.of(context).size.width,
                    color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
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
                                    onChange: (val) => {setState(() {})},
                                    isValidate:
                                        fieldValidation(_controllerName),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  DefaultTextFormField(
                                      hint: 'Описание',
                                      maxLines: 3,
                                      controller: _controllerDescription,
                                      maxLength: 50,
                                      isValidate: fieldValidation(
                                          _controllerDescription),
                                      onChange: (s) {
                                        setState(() {});
                                      }),
                                  if (!(widget.editingEvent != null &&
                                      widget.editingEvent!.important)) ...[
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        color: ClrStyle.backToBlack2C[
                                            sl<AuthConfig>().idx],
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
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
                                                      allDays = val;
                                                    });
                                                  },
                                                  value: allDays)
                                            ],
                                          ),
                                          SizedBox(
                                            height: 12.h,
                                          ),
                                          Container(
                                            color: ColorStyles.greyColor,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                    position: PreferredPosition
                                                        .bottom,
                                                    barrierColor:
                                                        Colors.transparent,
                                                    showArrow: false,
                                                    controller:
                                                        _customPopupMenuController1,
                                                    pressType:
                                                        PressType.singleClick,
                                                    menuBuilder: () {
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                      return _buildDatePicker(
                                                          context,
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
                                                              'd MMM yyyy г.',
                                                              'RU')
                                                          .format(fromDate),
                                                    ),
                                                  ),
                                                  if (!allDays) ...[
                                                    SizedBox(
                                                      width: 15.w,
                                                    ),
                                                    TimeItemTextFieldWidget(
                                                      controller:
                                                          _controllerFromTime,
                                                      validateText:
                                                          validateTextFields,
                                                      onChanged: (text) {
                                                        if (text != null &&
                                                            text.isNotEmpty) {
                                                          if (text.length ==
                                                                  2 &&
                                                              int.parse(text[
                                                                      0]) ==
                                                                  2 &&
                                                              int.parse(
                                                                      text[1]) >
                                                                  3) {
                                                            _controllerFromTime
                                                                .text = '';
                                                            setState(() {});
                                                          }
                                                        }
                                                      },
                                                    )
                                                  ],
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
                                                  GestureDetector(
                                                    onTap: () {
                                                      scrollController.animateTo(
                                                          scrollController
                                                              .position
                                                              .maxScrollExtent,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      200),
                                                          curve: Curves
                                                              .easeInOutQuint);
                                                    },
                                                    child: CustomPopupMenu(
                                                        position:
                                                            PreferredPosition
                                                                .bottom,
                                                        barrierColor:
                                                            Colors.transparent,
                                                        showArrow: false,
                                                        controller:
                                                            _customPopupMenuController2,
                                                        pressType: PressType
                                                            .singleClick,
                                                        menuBuilder: () {
                                                          FocusManager.instance
                                                              .primaryFocus
                                                              ?.unfocus();
                                                          return _buildDatePicker(
                                                              context,
                                                              (date, hide) {
                                                            if (hide) {
                                                              _customPopupMenuController2
                                                                  .hideMenu();
                                                            }
                                                            setState(() {
                                                              toDate = date;
                                                            });
                                                          }, toDate,
                                                              fromDate:
                                                                  fromDate);
                                                        },
                                                        child: TimeItemWidget(
                                                            text: DateFormat(
                                                                    'd MMM yyyy г.',
                                                                    'RU')
                                                                .format(
                                                                    toDate))),
                                                  ),
                                                  if (!allDays) ...[
                                                    SizedBox(
                                                      width: 15.w,
                                                    ),
                                                    TimeItemTextFieldWidget(
                                                      controller:
                                                          _controllerToTime,
                                                      validateText:
                                                          validateTextFields,
                                                      onChanged: (text) {
                                                        if (text != null &&
                                                            text.isNotEmpty) {
                                                          if (text.length ==
                                                                  2 &&
                                                              int.parse(text[
                                                                      0]) ==
                                                                  2 &&
                                                              int.parse(
                                                                      text[1]) >
                                                                  3) {
                                                            _controllerToTime
                                                                .text = '';
                                                            setState(() {});
                                                          }
                                                        }
                                                      },
                                                    )
                                                  ]
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
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          color: ClrStyle.backToBlack2C[
                                              sl<AuthConfig>().idx]),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 13.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Повтор',
                                            style: style2,
                                          ),
                                          Container(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              onTap: showSelectrorRepeat,
                                              // onPanEnd: (d) {
                                              //   showIconModal();
                                              // },
                                              behavior: HitTestBehavior.opaque,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    repeats[snapshot.data!]
                                                        ['repeat'],
                                                    key: repeatPicker,
                                                    style: const TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontSize: 16,
                                                        color:
                                                            Color(0xff969696),
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  ),
                                                  SizedBox(
                                                    width: 20.w,
                                                  ),
                                                  SvgPicture.asset(
                                                    SvgImg.upDownIcon,
                                                    color: ClrStyle
                                                            .black2CToWhite[
                                                        sl<AuthConfig>().idx],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        color: ClrStyle.backToBlack2C[
                                            sl<AuthConfig>().idx]),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 13.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Напоминание',
                                          style: style2,
                                        ),
                                        SwitchBtn(
                                          onChange: (val) {
                                            setState(() {
                                              notification = val;
                                            });
                                          },
                                          value: notification,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                    height: 57.h,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.r),
                                        color: ClrStyle.backToBlack2C[
                                            sl<AuthConfig>().idx]),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                                    : Image.asset(
                                                        Img.smile,
                                                        height: 33.h,
                                                        width: 33.h,
                                                        key: iconBtn,
                                                      ),
                                                SizedBox(
                                                  width: 20.w,
                                                ),
                                                SvgPicture.asset(
                                                  SvgImg.upDownIcon,
                                                  color:
                                                      ClrStyle.black2CToWhite[
                                                          sl<AuthConfig>().idx],
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
                                          color: widget.editingEvent == null ||
                                                  widget.editingEvent!.important
                                              ? const Color(0xFF70C8A3)
                                              : ColorStyles.redColor,
                                          text: title,
                                          validate: widget.editingEvent != null,
                                          code: false,
                                          textColor: Colors.white,
                                          onPressed: () {
                                            if (widget.editingEvent != null &&
                                                !widget
                                                    .editingEvent!.important) {
                                              context.read<EventsBloc>().add(
                                                      EventDeleteEvent(ids: [
                                                    widget.editingEvent!.id
                                                  ]));

                                              Navigator.pop(context);
                                            }
                                          },
                                          svg:
                                              'assets/icons/close_event_create.svg',
                                          svgHeight: 22.h,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                        child: CustomButton(
                                          color: ColorStyles.accentColor,
                                          text: widget.editingEvent != null
                                              ? 'Готово'
                                              : title,
                                          validate: isValidate(),
                                          code: false,
                                          textColor: Colors.white,
                                          onPressed: () =>
                                              createEvent(snapshot),
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
                                  color:
                                      ClrStyle.whiteTo17[sl<AuthConfig>().idx],
                                ),
                                padding: EdgeInsets.fromLTRB(0, 7.h, 0, 18.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 100.w,
                                      height: 5.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                        color: ColorStyles.greyColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      title,
                                      style: style1,
                                    )
                                  ],
                                )))
                      ],
                    )),
              ),
            ),
          );
        });
  }
}

Widget _buildDatePicker(BuildContext context,
    Function(DateTime dateTime, bool hideMenu) onTap, DateTime selectedDay,
    {DateTime? fromDate}) {
  DateTime currentDate = fromDate ?? DateTime.now();
  TextStyle style1 = TextStyle(
      color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
      fontSize: 20.sp,
      fontWeight: FontWeight.w800);
  TextStyle style2 = TextStyle(
      color: ColorStyles.blackColor,
      fontSize: 18.sp,
      fontWeight: FontWeight.w700);
  DateTime focusedDay = DateTime(selectedDay.year, selectedDay.month, 1);
  DateTime calendarStartDay = DateTime(selectedDay.year, selectedDay.month, 1);
  Widget _buildJustDay(context, DateTime date, events) {
    return CalendarJustItem(
        text: date.day.toString(),
        disabled: focusedDay.month != date.month ||
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
          color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
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
                  child: YearsMonthSelectWidget(
                    onTap: (i) {
                      setState(() {
                        if (calendarType == CalendarType.years) {
                          focusedDay =
                              DateTime(i, selectedDay.month, selectedDay.day);
                          calendarType = CalendarType.month;
                        } else {
                          if (!((i + 1) < currentDate.month &&
                              selectedDay.year == currentDate.year)) {
                            focusedDay = DateTime(
                                selectedDay.year, i + 1, selectedDay.day);
                            calendarType = CalendarType.days;
                          }
                        }
                        if (focusedDay.millisecondsSinceEpoch >
                            currentDate.millisecondsSinceEpoch) {
                          selectedDay = focusedDay;
                          onTap(focusedDay, false);
                        } else {
                          selectedDay =
                              currentDate.add(const Duration(days: 1));
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
                    onTap(date, false);
                    setState(() {
                      selectedDay = date;
                    });
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
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
