import 'package:be_loved/features/home/domain/entities/events/tag_entity.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/tag_modal.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

showModalCreateTag(BuildContext context, bool isCreate,
    [TagEntity? tagEntity, int? selectedEvent]) async {
  return await showMaterialModalBottomSheet(
      context: context,
      animationCurve: Curves.easeInOutQuint,
      duration: const Duration(milliseconds: 600),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return TagModal(
          isCreate: isCreate,
          editingTag: tagEntity,
          selectedEvent: selectedEvent,
        );
      });
}
