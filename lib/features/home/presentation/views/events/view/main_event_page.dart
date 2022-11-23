import 'package:be_loved/features/home/presentation/views/events/view/event_detail_view.dart';
import 'package:be_loved/features/home/presentation/views/events/view/event_page.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/all_events.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/main_page/events_page.dart';
import 'package:flutter/material.dart';

class MainEventPage extends StatefulWidget {
  const MainEventPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainEventPage> createState() => _MainEventPageState();
}

class _MainEventPageState extends State<MainEventPage> {
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
        EventPage(nextPage: nextPage,),
        EventDetailView(prevPage: prevPage),
      ],
    );
  }

  void nextPage(int id) {
    controller.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutQuint);
  }

  void prevPage() => controller.previousPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutQuint);
}
