import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/create_event_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'add_file_widget.dart';

showModalAddFile(BuildContext context, Function() onTap,) {
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
        return AddFileWidget(onTap: onTap, );
      });
}

