import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/helpers/date_time_helper.dart';

// ignore: must_be_immutable
class DayTextWidget extends StatelessWidget {
  EventEntity eventEntity;
  TextStyle? textStyle;
  String? additionString;
  DayTextWidget(
      {required this.eventEntity, this.textStyle, this.additionString});

  @override
  Widget build(BuildContext context) {
    return Text(
      getTextFromDate(eventEntity.datetimeString, additionString),
      style: textStyle ??
          TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
            color: getColorFromDays(
                eventEntity.datetimeString, eventEntity.important),
          ),
    );
  }
}
