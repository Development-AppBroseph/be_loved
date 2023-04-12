import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviewItem extends StatelessWidget {
  final String title;
  final String text;
  final String image;
  const PreviewItem({required this.text, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: ColorStyles.greyColor,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(image)
                    // image: title == 'Планируй события'
                    //     ? const AssetImage(
                    //         'assets/images/onboarding_second.png')
                    //     : title == "Сохраняй моменты"
                    //         ? const AssetImage(
                    //             'assets/images/onboarding_first.png')
                    //         : const AssetImage(
                    //             'assets/images/onboarding_third.png'),
                  ),
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
