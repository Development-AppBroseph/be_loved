import 'package:be_loved/features/home/presentation/views/relationships/main_relation_ships_page.dart';
import 'package:flutter/material.dart';

import 'relation_ship_settings_page.dart/view/relation_ships_settings_page.dart';

class RelationAndRelationSettingsPage extends StatefulWidget {
  final Function(int id) nextPage;
  final Function() toStaticsPage;
  final Function() toAllEvents;
  const RelationAndRelationSettingsPage({Key? key, required this.toAllEvents, required this.nextPage, required this.toStaticsPage}) : super(key: key);

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
        MainRelationShipsPage(nextPage: widget.nextPage, toRelationSettingsPage: nextPage, toStaticsPage: widget.toStaticsPage,),
        RelationShipsSettingsPage(prevPage: prevPage, toStaticsPage: widget.toStaticsPage, toAllEvents: widget.toAllEvents,),
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
