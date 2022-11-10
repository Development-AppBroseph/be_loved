import 'package:be_loved/features/home/presentation/views/relationships/account/account_page.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ships_page.dart';
import 'package:flutter/material.dart';

class MainRelationShipsPage extends StatefulWidget {
  MainRelationShipsPage({Key? key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: controller,
      children: [
        RelationShipsPage(nextPage: nextPage),
        AccountPage(prevPage: prevPage),
      ],
    );
  }

  void nextPage() => controller.animateToPage(1, duration: Duration(milliseconds: 600), curve: Curves.easeInOutQuint);

  void prevPage() => controller.animateToPage(0, duration: Duration(milliseconds: 600), curve: Curves.easeInOutQuint);
}
