import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/helpers/truncate_text_helper.dart';
import 'package:be_loved/core/widgets/texts/day_text_widget.dart';
import 'package:be_loved/core/widgets/texts/important_text_widget.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class EventsListWidget extends StatelessWidget {
  List<EventEntity> events;
  final Function(int i) onTap;
  EventsListWidget({required this.events, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return _events(events);
  }
  Widget _events(List<EventEntity> events) {
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
        color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx], fontWeight: FontWeight.w700, fontSize: 20.sp);
    TextStyle style2 = TextStyle(
        color: ColorStyles.greyColor,
        fontWeight: FontWeight.w700,
        fontSize: 15.sp);

    Color? colorDays = checkColor(eventEntity.datetimeString);

    return GestureDetector(
      onTap: (){
        onTap(eventEntity.id);
      },
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  truncateWithEllipsis(22, eventEntity.title), 
                  style: style1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5.h),
                eventEntity.important
                ? ImportantTextWidget()
                : RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Добавил(а): ${eventEntity.eventCreator.username}',
                        style: style2),
                  ]),
                )
              ],
            ),
            const Spacer(),
            DayTextWidget(eventEntity: eventEntity)
          ],
        ),
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