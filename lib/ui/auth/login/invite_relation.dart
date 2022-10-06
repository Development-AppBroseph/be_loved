import 'dart:async';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/ui/auth/login/invite_for_start_relationship.dart';
import 'package:be_loved/ui/auth/login/invite_partner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        child: StreamBuilder<int>(
            initialData: 2,
            stream: streamController.stream,
            builder: (context, snapshot) {
              return BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                var bloc = BlocProvider.of<AuthBloc>(context);
                return PageView(
                  scrollDirection: Axis.vertical,
                  physics: bloc.user?.love != null
                      ? snapshot.data == 2
                          ? const NeverScrollableScrollPhysics()
                          : null
                      : const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (value) => streamController.add(value),
                  children: [
                    InviteForStartRelationship(
                        nextPage: () => previewPage(context),
                        streamController: streamController),
                    InvitePartner(
                        nextPage: nextPage,
                        previousPage: previousPage,
                        streamController: streamController),
                  ],
                );
              });
            }),
      ),
    );
  }

  void nextPage() => pageController.previousPage(
      duration: const Duration(milliseconds: 1200), curve: Curves.easeInOut);

  void previewPage(BuildContext context) {
    BlocProvider.of<AuthBloc>(context).add(DeleteInviteUser());
    pageController.nextPage(
        duration: const Duration(milliseconds: 1200), curve: Curves.easeInOut);
  }
}
