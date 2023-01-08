import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/presentation/views/relationships/account/widgets/dialog_card.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';



class ImageChangePopup extends StatelessWidget {
  final Function(ImageSource source)? pickImage;
  final Function() mirror;
  ImageChangePopup({required this.mirror, required this.pickImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248.w,
      height: 120.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 20.w,
            color: Colors.black.withOpacity(0.1)
          )
        ]
      ),
      child: CupertinoCard(
        padding: EdgeInsets.zero,
        color: ClrStyle.whiteToBlack2C[sl<AuthConfig>().idx],
        elevation: 0,
        radius: BorderRadius.circular(30.r),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 9.h),
          child: Column(
            children: [
              DilogTabs(
                image: SvgImg.selectedImage,
                title: "Выбрать фото",
                onTap: pickImage,
              ),
              DilogTabs(
                image: SvgImg.mirror,
                title: "Отзеркалить",
                mirror: mirror,
                onTap: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}