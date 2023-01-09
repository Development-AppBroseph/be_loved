import 'package:be_loved/features/home/presentation/views/relationships/account/view/account_page.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ships_page.dart';
import 'package:flutter/material.dart';

class MainRelationShipsPage extends StatefulWidget {
  final Function(int id) nextPage;
  final Function() toRelationSettingsPage;
  final Function() toStaticsPage;
  const MainRelationShipsPage({Key? key, required this.nextPage, required this.toRelationSettingsPage, required this.toStaticsPage}) : super(key: key);

  @override
  State<MainRelationShipsPage> createState() => _MainRelationShipsPageState();
}

class _MainRelationShipsPageState extends State<MainRelationShipsPage> {
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
        RelationShipsPage(nextPage: nextPage, toDetailPage: widget.nextPage, toRelationSettingsPage: widget.toRelationSettingsPage, toStaticsPage: widget.toStaticsPage,),
        AccountPage(prevPage: prevPage),
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
