import 'dart:async';
import 'package:be_loved/ui/auth/login/inviteFor_start_relationship.dart';
import 'package:be_loved/ui/auth/login/invite_partner.dart';
import 'package:flutter/material.dart';

class InviteRelation extends StatelessWidget {
  InviteRelation({Key? key, required this.previousPage}) : super(key: key);

  final VoidCallback previousPage;

  final streamController = StreamController<int>();
  final pageController =
      PageController(initialPage: 1, viewportFraction: 1.0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: PageView(
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: (value) => streamController.add(value + 1),
          children: [
            InviteForStartRelationship(nextPage: previewPage),
            InvitePartner(nextPage: nextPage, previousPage: previousPage),
          ],
        ),
      ),
    );
  }

  void nextPage() => pageController.previousPage(
      duration: const Duration(milliseconds: 1200), curve: Curves.easeInOut);

  void previewPage() => pageController.nextPage(
      duration: const Duration(milliseconds: 1200), curve: Curves.easeInOut);
}
