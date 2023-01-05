import 'dart:io';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/settings_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void albumItemSettingsModal(
  BuildContext context,
  Offset offset,
  Function() onDeleteAlbum,
  Function() onDeleteFile,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        bool isEditing = false;
        return AlertDialog(
          insetPadding: EdgeInsets.only(
              top: offset.dy + (25.h),
              left: offset.dx - (177.h)),
          alignment: Alignment.topLeft,
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          elevation: 0,
          // iconColor: Colors.transparent,
          content: StatefulBuilder(builder: ((context, setState) {
            return SizedBox(
              height: 220.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsItem(
                    onTap: () {
                      onDeleteAlbum();
                    },
                    text: 'Удалить альбом',
                    icon: SvgImg.galleryWithLine,
                    color: ColorStyles.redColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(34.r),
                      topRight: Radius.circular(34.r),
                    ),
                    iconSize: Size(16.w, 18.h),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  SettingsItem(
                    onTap: () {
                      onDeleteFile();
                    },
                    text: 'Удалить файл',
                    icon: SvgImg.trash,
                    color: ColorStyles.redColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(34.r),
                      bottomRight: Radius.circular(34.r),
                    ),
                    iconSize: Size(16.w, 18.h),
                  )
                ],
              ),
            );
          })),
        );
      },
    );
