import 'package:be_loved/features/home/presentation/views/relationships/relation_and_relation_settings_page.dart';
import 'package:be_loved/features/home/presentation/views/relationships/statics/statics_view.dart';
import 'package:flutter/material.dart';

class RelationAndStatsPage extends StatefulWidget {
  final Function(int id) nextPage;
  final Function() toAllEvents;
  const RelationAndStatsPage({Key? key, required this.nextPage, required this.toAllEvents}) : super(key: key);

  @override
  State<RelationAndStatsPage> createState() => _RelationAndStatsPageState();
}

class _RelationAndStatsPageState extends State<RelationAndStatsPage> {
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
      children: [
        RelationAndRelationSettingsPage(nextPage: widget.nextPage, toStaticsPage: nextPage, toAllEvents: widget.toAllEvents,),
        StaticsView(prevPage: prevPage),
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
