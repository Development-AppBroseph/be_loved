import 'package:be_loved/features/home/data/models/home/hashTag.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/tag_modal.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/create_event_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

showModalCreateTag(BuildContext context, bool isCreate) {
  showMaterialModalBottomSheet(
    context: context,
    animationCurve: Curves.easeInOutQuint,
    duration: const Duration(milliseconds: 600),
    backgroundColor: Colors.transparent,
    builder: (context) {
      return TagModal(isCreate: isCreate);
    });
}

