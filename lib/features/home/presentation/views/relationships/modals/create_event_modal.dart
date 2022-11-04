import 'package:be_loved/features/home/presentation/views/relationships/modals/create_event_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

showModalCreateEvent(BuildContext context, Function() onTap) {
  showMaterialModalBottomSheet(
    animationCurve: Curves.easeInOutQuint,
      elevation: 12,
      barrierColor: Color.fromRGBO(0, 0, 0, 0.2),
      duration: Duration(milliseconds: 600),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40.h),
        topRight: Radius.circular(40.h),
      )),
      context: context,
      builder: (context) {
        return CreateEventWidget(onTap: onTap,);
      });
}

