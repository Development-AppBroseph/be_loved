import 'dart:math';

import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/ui/auth/login/invite_for.dart';
import 'package:be_loved/ui/auth/login/relationships.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class InviteForStartRelationship extends StatelessWidget {
  InviteForStartRelationship({
    Key? key,
    required this.nextPage,
    required this.streamController,
    required this.isSwipe,
  }) : super(key: key);

  bool isSwipe;
  final VoidCallback nextPage;
  final streamController;
  final pageController = PageController(viewportFraction: 1.0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    // print('offset: ${pageController.position}');
    return Scaffold(
      body: SafeArea(
        bottom: true,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              InviteFor(
                nextPage: nextPage1,
                isSwiping: isSwipe,
                previewPage: (() {
                  BlocProvider.of<AuthBloc>(context).add(DeleteInviteUser());
                  nextPage();
                  streamController.add(1);
                }),
              ),
              RelationShips(previewPage: nextPage, prevPage: previousPage)
            ],
          ),
        ),
      ),
    );
  }

  void nextPage1() => pageController.nextPage(
      duration: const Duration(milliseconds: 1200), curve: Curves.ease);

  void previousPage() => pageController.previousPage(
      duration: const Duration(milliseconds: 1200), curve: Curves.ease);
}
