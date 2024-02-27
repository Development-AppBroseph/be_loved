import 'package:be_loved/features/auth/presentation/views/login/invite_relation.dart';
import 'package:be_loved/features/invite/presentation/invite_real_or_imaginated/add_jokers_name_photo_screen.dart';
import 'package:be_loved/features/invite/presentation/invite_real_or_imaginated/confirm_relationship_screen.dart';
import 'package:be_loved/features/invite/presentation/invite_real_or_imaginated/edit_virtual_joker.dart';
import 'package:be_loved/features/invite/presentation/invite_real_or_imaginated/invite_real.dart';
import 'package:flutter/material.dart';

abstract class InviteRealBloc extends State<InviteRealOrImaginated> {
  void goToInvite() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InviteRelation(
          previousPage: () {},
        ),
      ),
    );
  }

  void goToCreateJoker() {
    Navigator.pop(context);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        isDismissible: true,
        builder: (BuildContext context) {
          return const CreateVirtualJokerScreen();
        });
  }

  void goToEditJoker() {
    Navigator.pop(context);
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        isDismissible: true,
        builder: (BuildContext context) {
          return const EditVirtualJoker();
        });
  }

  void goBack() {
    Navigator.pop(context);
  }
}
