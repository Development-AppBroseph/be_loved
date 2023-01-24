import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';




class OptionBlackBtn extends StatelessWidget {
  String text;
  bool isSelected;
  Function()? onTap;
  OptionBlackBtn({this.onTap, required this.text, this.isSelected = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 37.h,
        child: CupertinoCard(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
          radius: BorderRadius.circular(20.r),
          child: Stack(
            children: [
              if(!isSelected)
              Positioned.fill(
                child: CupertinoCard(
                  elevation: 0,
                  margin: EdgeInsets.all(2.w),
                  radius: BorderRadius.circular(16.r),
                  color: ClrStyle.whiteTo17[sl<AuthConfig>().idx]
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Center(
                  child: Text(
                    text, 
                    style: TextStyles(context).white_18_w800.copyWith(
                      color: isSelected
                      ? ClrStyle.whiteTo17[sl<AuthConfig>().idx]
                      : ClrStyle.black17ToWhite[sl<AuthConfig>().idx]
                    )
                  )
                ),
              ),



              
            ],
          ),
        ),
      ),
    );
  }
}