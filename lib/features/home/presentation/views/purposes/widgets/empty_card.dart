import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class EmptyCard extends StatelessWidget {
  final bool isAvailable;
  final bool isModal;
  const EmptyCard({this.isAvailable = false, this.isModal = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 378.w,
      height: 70.w,
      child: CupertinoCard(
        margin: EdgeInsets.zero,
        radius: BorderRadius.circular(40.r),
        color: ColorStyles.greyColor,
        elevation: 0,
        child: Stack(
          children: [
            Positioned.fill(
              child: CupertinoCard(
                margin: EdgeInsets.all(1.w),
                radius: BorderRadius.circular(37.r),
                color: isModal ? ClrStyle.whiteToBlack2C[sl<AuthConfig>().idx] : ClrStyle.backToBlack2C[sl<AuthConfig>().idx],
                elevation: 0,
              )
            ),
            Center(
              child: Text(isAvailable ? 'Доступных целей нет :(' : 'Целей нет :(', style: TextStyles(context).grey_20_w700,)
            ),
          ],
        )
      ),
    );
  }
}