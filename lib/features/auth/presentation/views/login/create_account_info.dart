import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/features/auth/presentation/views/image/avatar.dart';
import 'package:be_loved/features/auth/presentation/views/login/name.dart';
import 'package:be_loved/features/home/presentation/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            AvatarPage(
              nextPage: nextPage,
              previousPage: () => previousPage(context),
            ),
            HomePage(),
            // InviteRelation(
            //   previousPage: () => previousPage(context),
            // )
          ],
        ),
      ),
    );
  }

  void nextPage() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  void previousPage(BuildContext context) {
    pageController.previousPage(
        duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    BlocProvider.of<AuthBloc>(context).add(TextFieldFilled(true));
  }
}
