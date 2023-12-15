import 'package:flutter/material.dart';

class HeaderDialog extends StatelessWidget {
  final String headerText;
  final String headerDescription;
  const HeaderDialog({
    super.key,
    required this.headerDescription,
    required this.headerText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Text(
            headerText,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            headerDescription,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
