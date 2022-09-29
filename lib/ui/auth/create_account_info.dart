import 'package:be_loved/ui/auth/name.dart';
import 'package:be_loved/ui/auth/avatar.dart';
import 'package:be_loved/ui/auth/invite_relation.dart';
import 'package:flutter/material.dart';

class CreateAccountInfo extends StatelessWidget {
  CreateAccountInfo({Key? key}) : super(key: key);
  
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
            InputNamePage(nextPage: nextPage),
            AvatarPage(nextPage: nextPage, previousPage: previousPage),
            InviteRelation(previousPage: previousPage)
          ],
        ),
      ),
    );
  }

  void nextPage() => pageController.nextPage(duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);

  void previousPage() => pageController.previousPage(duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
}
