import 'dart:math';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/utils/images.dart';

class AddPhotoCard extends StatelessWidget {
  final Function() onTap;
  final Key? keyAdd;
  final Color? color;
  final String? text;
  const AddPhotoCard({this.text, this.color, required this.onTap, this.keyAdd});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CupertinoCard(
        padding: EdgeInsets.all(20.w),
        margin: EdgeInsets.zero,
        elevation: 0,
        radius: BorderRadius.circular(40.r),
        color: color ?? ClrStyle.whiteToBlack2C[sl<AuthConfig>().idx],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  SvgImg.camera,
                  height: 23.4.h,
                  width: 26.w,
                  color: ClrStyle.black2CToWhite[sl<AuthConfig>().idx],
                ),
                SizedBox(
                  width: 19.w,
                ),
                Text(
                  text ?? 'Добавить фото',
                  style: TextStyles(context).black_20_w800,
                )
              ],
            ),
            Opacity(
              opacity: text == null || text == 'Добавить файлы' ? 1 : 0,
              child: Transform.rotate(
                  angle: pi / 4,
                  child: SvgPicture.asset(
                    SvgImg.add,
                    key: keyAdd,
                    width: 19.w,
                    color: ClrStyle.black2CToWhite[sl<AuthConfig>().idx],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
