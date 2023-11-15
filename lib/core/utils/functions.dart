import 'package:be_loved/features/home/domain/entities/purposes/actual_entiti.dart';
import 'package:be_loved/features/home/domain/entities/purposes/promos_entiti.dart';
import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:be_loved/features/home/presentation/views/purposes/purposes_page.dart';
import 'package:be_loved/features/home/presentation/views/purposes/widgets/purpose_card.dart';
import 'package:flutter/material.dart';

import '../../features/home/presentation/views/purposes/widgets/promos_card.dart';

class Functions {
  static void showPromosDilog(
    PromosEntiti promosEntiti,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) => PromosDilog(
        promosEntiti: promosEntiti,
      ),
    );

    // SmartDialog.show(
    //   animationType: SmartAnimationType.fade,
    //   builder: (context) =>
    // );
  }

  static void showPurposeDilog(PurposeEntity purposeEntity,
      BuildContext context, Function() onComplete) {
    showDialog(
      context: context,
      builder: (context) => PurposeDilog(
        purposeEntity: purposeEntity,
        onComplete: onComplete,
      ),
    );
  }

  static void showActualDialog(
    ActualEntiti actualEntiti,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) => ActualDialog(
        actualEntiti: actualEntiti,
      ),
    );
  }
}
