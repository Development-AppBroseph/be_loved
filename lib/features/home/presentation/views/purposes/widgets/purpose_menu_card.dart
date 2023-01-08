import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../theme/data/entities/clr_style.dart';



class PurposeMenuCard extends StatelessWidget {
  final String text;
  final int index;
  final int selectedType;
  const PurposeMenuCard({required this.text, required this.index, required this.selectedType});

  @override
  Widget build(BuildContext context) {
    return CupertinoCard(
      margin: EdgeInsets.zero,
      elevation: 0,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: index == selectedType && index == 0
          ? ClrStyle.black2CToWhite[sl<AuthConfig>().idx]
          : index == selectedType  
          ? ColorStyles.primarySwath 
          : ClrStyle.whiteTo17[sl<AuthConfig>().idx]
      ),
      color: index == selectedType && index == 0
      ? ClrStyle.black2CToWhite[sl<AuthConfig>().idx]
      : index == selectedType  
      ? ColorStyles.primarySwath 
      : ClrStyle.whiteTo17[sl<AuthConfig>().idx],
      radius: BorderRadius.circular(20.r),
      child: Center(
        child: Text(
          text, 
          style: TextStyles(context).white_18_w800.copyWith(
            color: index == selectedType
            ? ClrStyle.whiteTo17[sl<AuthConfig>().idx]
            : ColorStyles.greyColor
          )
        )
      ),
    );
  }
}