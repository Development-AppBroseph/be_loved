import 'package:flutter/material.dart';

class BottomSheetGreyLine extends StatelessWidget {
  const BottomSheetGreyLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: 100,
      margin: const EdgeInsets.only(top: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff969696)
      ),
    );
  }
}
