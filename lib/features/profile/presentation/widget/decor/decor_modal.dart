import 'package:be_loved/features/home/presentation/views/events/widgets/add_events_bottomsheet.dart';
import 'package:be_loved/features/profile/presentation/widget/decor/decor_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

showModalDecor(BuildContext context, Function() onTap) {
  showMaterialModalBottomSheet(
    animationCurve: Curves.easeInOutQuint,
    duration: const Duration(milliseconds: 600),
    context: context,
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.vertical(
    //     top: Radius.circular(50.r),
    //   ),
    // ),
    backgroundColor: Colors.transparent,
    builder: (context) =>
        const DecorBottomsheet(),
  );
}