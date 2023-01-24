import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class PreviewItem extends StatelessWidget {
  final String title;
  final String text;
  PreviewItem({required this.text, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              color: ColorStyles.greyColor,
              width: MediaQuery.of(context).size.width,
              height: 601.h,
            ),
            Positioned(
              bottom: 4.h,
              right: 0,
              left: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: TextStyles(context).black_35_w800.copyWith(color: ColorStyles.black2Color),)
                ],
              )
            )
          ],
        ),
        SizedBox(height: 4.h,),
        Text(
          text,
          style: TextStyles(context).grey_15_w800,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}