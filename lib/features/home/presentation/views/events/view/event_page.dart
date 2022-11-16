import 'package:be_loved/features/home/presentation/views/events/widgets/all_events.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/main_page/events_page.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({
    Key? key,
  }) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
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
        MainEventsPage(nextPage: nextPage),
        AllEeventsPage(prevPage: prevPage),
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
