import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/settings_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> FileTypeModal(
  BuildContext context,
  Offset offset,
  Function() onFirst,
  Function() onSecond,
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
              left: offset.dx - (202.h)),
          alignment: Alignment.topLeft,
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          elevation: 0,
          // iconColor: Colors.transparent,
          content: StatefulBuilder(builder: ((context, setState) {
            return SizedBox(
              height: 120.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsItem(
                    onTap: () {
                      onFirst();
                    },
                    text: 'Выбрать фото',
                    icon: SvgImg.gallery,
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
                      onSecond();
                    },
                    text: 'Выбрать видео',
                    icon: SvgImg.galleryWithLine,
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
