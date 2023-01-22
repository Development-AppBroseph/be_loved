import 'package:be_loved/features/home/presentation/views/events/widgets/all_events.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_and_stats_page.dart';
import 'package:flutter/material.dart';

class MainAndAllPage extends StatefulWidget {
  Function(int id) toDetail;
  MainAndAllPage({Key? key, required this.toDetail}) : super(key: key);

  @override
  State<MainAndAllPage> createState() => _MainAndAllPageState();
}

class _MainAndAllPageState extends State<MainAndAllPage> {
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
      onPageChanged: (value) {
        physics = value == 0
            ? const NeverScrollableScrollPhysics()
            : const ClampingScrollPhysics();
        setState(() {});
      },
      children: [
        RelationAndStatsPage(nextPage: widget.toDetail, toAllEvents: nextPage,),
        AllEeventsPage(prevPage: prevPage, toDetailPage: widget.toDetail,),
      ],
    );
  }

  void nextPage() {
    controller.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutQuint);
  }

  void prevPage() => controller.previousPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutQuint);
}
