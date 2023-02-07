import 'dart:ui';

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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: ColorStyles.greyColor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: title == 'Планируй события'
                      ? Image.asset('assets/images/onboarding_second.png')
                      : Image.asset('assets/images/onboarding_first.png'),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              child: Container(
                height: 111.h,
                margin: EdgeInsets.only(bottom: 267.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 0.h),
                      child: Text(
                        title,
                        style: TextStyles(context)
                            .black_35_w800
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      text,
                      style: TextStyles(context)
                          .grey_15_w800
                          .copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
