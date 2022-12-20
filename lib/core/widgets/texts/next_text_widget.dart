import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/utils/helpers/date_time_helper.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NextEventTextWidget extends StatelessWidget {
  final EventEntity eventEntity;
  const NextEventTextWidget({required this.eventEntity});

  @override
  Widget build(BuildContext context) {
    EventsBloc eventsBloc = context.read<EventsBloc>();
    EventEntity? nextEvent;
    if (eventsBloc.events.first.id != eventEntity.id) {
      nextEvent = eventsBloc.events.first;
    } else if (eventsBloc.events.length >= 2) {
      nextEvent = eventsBloc.events[1];
    }
    bool isNextMonth = int.parse(nextEvent!.datetimeString) >= 29 || DateTime.now().year != DateTime.now().add(Duration(days: int.parse(nextEvent.datetimeString))).year;
    return nextEvent != null && eventEntity.id == eventsBloc.events.first.id
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isNextMonth
                ? 'Далее:'
                : getTextFromDate(nextEvent.datetimeString, ':'),
                style: TextStyle(
                  color: ColorStyles.greyColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                nextEvent.title,
                style: TextStyle(
                    color: ColorStyles.greyColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700),
              ),
            ],
          )
        : SizedBox.shrink();
  }
}
