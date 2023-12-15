import 'package:be_loved/features/invite/presentation/invite_now_or_later/invite_now_screen.dart';
import 'package:be_loved/features/invite/presentation/invite_real_or_imaginated/invite_real.dart';
import 'package:flutter/material.dart';

abstract class InviteNowBloc extends State<InviteNowOrLaterScreen> {
  void goToInvite() {
    Navigator.pop(context);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        isDismissible: true,
        builder: (BuildContext context) {
          return const InviteRealOrImaginated();
        });
  }

  void goBack() {
    Navigator.pop(context);
  }
}
