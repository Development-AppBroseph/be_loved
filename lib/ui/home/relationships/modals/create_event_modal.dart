import 'package:be_loved/ui/home/relationships/modals/create_event_widget.dart';
import 'package:be_loved/ui/home/relationships/widgets/calendar_just_item.dart';
import 'package:be_loved/ui/home/relationships/widgets/calendar_selected_item.dart';
import 'package:be_loved/ui/home/relationships/widgets/time_item_text_field_widget.dart';
import 'package:be_loved/widgets/buttons/switch_btn.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/helpers/constants.dart';
import '../../../../core/widgets/text_fields/default_text_form_field.dart';
import '../widgets/time_item_widget.dart';
import '../widgets/years_month_select_widget.dart';

showModalCreateEvent(BuildContext context, Function() onTap) {
  showMaterialModalBottomSheet(
    animationCurve: Curves.easeInOutQuint,
      elevation: 12,
      barrierColor: Color.fromRGBO(0, 0, 0, 0.2),
      duration: Duration(milliseconds: 600),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(28.h),
        topRight: Radius.circular(28.h),
      )),
      context: context,
      builder: (context) {
        return CreateEventWidget(onTap: onTap,);
      });
}

