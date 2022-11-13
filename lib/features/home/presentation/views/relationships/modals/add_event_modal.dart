import 'package:be_loved/features/home/presentation/views/events/widgets/add_events_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

showModalAddEvent(BuildContext context, ) {
  showMaterialModalBottomSheet(
    animationCurve: Curves.easeInOutQuint,
      elevation: 12,
      barrierColor: Color.fromRGBO(0, 0, 0, 0.2),
      duration: Duration(milliseconds: 600),
      backgroundColor: Colors.transparent,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(
      //     top: Radius.circular(50.r),
      //   ),
      // ),
      context: context,
      builder: (context) {
        return const AddEventBottomsheet();
      });
}