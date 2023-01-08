import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/colors/color_styles.dart';


class NewEventBtn extends StatelessWidget {
  final Function() onTap;
  final bool isActive;
  final String? text;
  NewEventBtn({this.text, required this.onTap, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(isActive) onTap();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 55.h,
              decoration: BoxDecoration(
                border: Border.all(color: isActive ? ColorStyles.accentColor : ColorStyles.greyColor, width: 1.w),
                color: isActive ? ColorStyles.accentColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Text(text ?? 'Новое событие',
                    style: TextStyles(context).white_20_w800.copyWith(color: isActive ? ClrStyle.whiteTo17[sl<AuthConfig>().idx] : ColorStyles.greyColor))),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 55.h,
                width: 55.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      SvgImg.addNewEvent,
                      color: isActive ? ClrStyle.whiteTo17[sl<AuthConfig>().idx] : ColorStyles.greyColor,
                      width: 22.15.h,
                      height: 22.15.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}