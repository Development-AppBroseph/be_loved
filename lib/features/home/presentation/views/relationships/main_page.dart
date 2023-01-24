import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/views/events/view/event_detail_view.dart';
import 'package:be_loved/features/home/presentation/views/relationships/account/view/account_page.dart';
import 'package:be_loved/features/home/presentation/views/relationships/main_relation_ships_page.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_and_relation_settings_page.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_and_stats_page.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ships_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
        RelationAndStatsPage(nextPage: nextPage),
        EventDetailView(prevPage: prevPage),
      ],
    );
  }

  void nextPage(int id) {
    context.read<EventsBloc>().eventDetailSelectedId = id;
    controller.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutQuint);
  }

  void prevPage() => controller.previousPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutQuint);
}
