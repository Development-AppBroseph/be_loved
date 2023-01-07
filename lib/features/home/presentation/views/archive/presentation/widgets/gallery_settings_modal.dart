import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/settings_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void gallerySettingsModal(
  BuildContext context,
  Offset offset,
  Function() onDelete,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return AlertDialog(
            insetPadding:
                EdgeInsets.only(top: offset.dy + 25.h, left: offset.dx - 195.h),
            alignment: Alignment.topLeft,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            // iconColor: Colors.transparent,
            content: SizedBox(
              height: 55.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SettingsItem(
                  //   onTap: onEdit,
                  //   text: 'Редактировать',
                  //   icon: SvgImg.edit,
                  // ),
                  // SizedBox(
                  //   height: 5.h,
                  // ),
                  SettingsItem(
                    onTap: onDelete,
                    text: 'Удалить файл',
                    icon: SvgImg.trash,
                    color: ColorStyles.redColor,
                    borderRadius: BorderRadius.circular(34.r),
                    iconSize: Size(16.w, 18.h),
                  )
                ],
              ),
            ));
      },
    );
