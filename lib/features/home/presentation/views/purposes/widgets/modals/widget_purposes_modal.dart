import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/modals/purposes_modal.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

showModalWidgetPurposes(BuildContext context, Function(PurposeEntity purposeEntity) onSelect) async {
  return await showMaterialModalBottomSheet(
    context: context,
    animationCurve: Curves.easeInOutQuint,
    duration: const Duration(milliseconds: 600),
    backgroundColor: Colors.transparent,
    builder: (context) {
      return PurposesModal(onSelect: onSelect);
    });
}

