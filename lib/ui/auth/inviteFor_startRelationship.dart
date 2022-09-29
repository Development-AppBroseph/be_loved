import 'package:be_loved/ui/auth/invite_for.dart';
import 'package:be_loved/ui/auth/relationships.dart';
import 'package:flutter/material.dart';

class InviteForStartRelationship extends StatelessWidget {
  InviteForStartRelationship({Key? key, required this.nextPage}) : super(key: key);
  
  final VoidCallback nextPage;
  final pageController = PageController(viewportFraction: 1.0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            InviteFor(nextPage: nextPage1, previewPage: nextPage),
            RelationShips(previewPage: nextPage, prevPage: previousPage)
          ],
        ),
      ),
    );
  }

  void nextPage1() => pageController.nextPage(duration: const Duration(milliseconds: 1200), curve: Curves.easeInOut);

  void previousPage() => pageController.previousPage(duration: const Duration(milliseconds: 1200), curve: Curves.easeInOut);
}
