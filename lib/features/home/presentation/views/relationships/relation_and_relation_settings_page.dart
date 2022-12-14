import 'package:be_loved/features/home/presentation/views/relationships/account/view/account_page.dart';
import 'package:be_loved/features/home/presentation/views/relationships/main_relation_ships_page.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ships_page.dart';
import 'package:flutter/material.dart';

import 'relation_ships_settings_page.dart';

class RelationAndRelationSettingsPage extends StatefulWidget {
  final Function(int id) nextPage;
  const RelationAndRelationSettingsPage({Key? key, required this.nextPage}) : super(key: key);

  @override
  State<RelationAndRelationSettingsPage> createState() => _RelationAndRelationSettingsPageState();
}

class _RelationAndRelationSettingsPageState extends State<RelationAndRelationSettingsPage> {
  final PageController controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  ScrollPhysics physics = const NeverScrollableScrollPhysics();

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: physics,
      controller: controller,
      // onPageChanged: (value) {
      //   physics = value == 0
      //       ? const NeverScrollableScrollPhysics()
      //       : const ClampingScrollPhysics();
      //   setState(() {});
      // },
      children: [
        MainRelationShipsPage(nextPage: widget.nextPage, toRelationSettingsPage: nextPage),
        RelationShipsSettingsPage(prevPage: prevPage),
      ],
    );
  }

  void nextPage() => controller.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutQuint);

  void prevPage() => controller.previousPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutQuint);
}
