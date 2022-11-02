import 'package:be_loved/ui/home/relationships/modals/create_event_modal.dart';
import 'package:be_loved/ui/home/relationships/widgets/calendar_just_item.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/constants.dart';
import 'calendar_selected_item.dart';


class YearsMonthSelectWidget extends StatelessWidget {
  final Function(int index) onTap;
  final DateTime focusedDay;
  final CalendarType calendarType;
  const YearsMonthSelectWidget({required this.calendarType ,required this.focusedDay, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, childAspectRatio: 93/50),
      itemBuilder: (context, i) {
        int currentYear = (DateTime.now().year+i);
        String text = calendarType == CalendarType.month ? months[i] : currentYear.toString();
        print('TEXT: ${text}');
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            onTap(calendarType == CalendarType.years ? currentYear : i);
          },
          child: (calendarType == CalendarType.month && i+1 == focusedDay.month) 
            || (calendarType == CalendarType.years && currentYear == focusedDay.year)
            ? CalendarSelectedItem(text: text)
            : CalendarJustItem(text: text)
        );
      }
    );
  }
}