import 'package:be_loved/features/auth/presentation/views/login/invite_relation.dart';
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
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => InviteRelation(
    //       previousPage: () {},
    //     ),
    //   ),
    // );
  }

  void goBack() {
    Navigator.pop(context);
  }
}
