import 'dart:io';
import 'dart:ui';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/presentation/bloc/events/events_bloc.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/settings_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

void eventSettingsModal(
  BuildContext context,
  Offset offset,
  bool isImportant,
  Function() onEdit,
  Function() onDelete,
  Function() onAddToHome,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return AlertDialog(
            insetPadding:
                EdgeInsets.only(top: offset.dy + 25.h, left: offset.dx - 177.h),
            alignment: Alignment.topLeft,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            // iconColor: Colors.transparent,
            content: SizedBox(
              height: 200.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SettingsItem(
                    onTap: onEdit,
                    text: 'Редактировать',
                    icon: SvgImg.edit,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  SettingsItem(
                    onTap: () {
                      if (context.read<EventsBloc>().eventsInHome.length != 3) {
                        onAddToHome();
                      }
                    },
                    text: 'На главный экран',
                    icon: SvgImg.smartphone,
                    opacity: context.read<EventsBloc>().eventsInHome.length != 3
                        ? null
                        : 0.8,
                    borderRadius: !isImportant
                        ? BorderRadius.zero
                        : BorderRadius.only(
                            bottomLeft: Radius.circular(34.r),
                            bottomRight: Radius.circular(34.r),
                          ),
                    iconSize: Size(16.w, 25.h),
                  ),
                  if (!isImportant) ...[
                    SizedBox(
                      height: 5.h,
                    ),
                    SettingsItem(
                      onTap: onDelete,
                      text: 'Удалить событие',
                      icon: SvgImg.trash,
                      color: ColorStyles.redColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(34.r),
                        bottomRight: Radius.circular(34.r),
                      ),
                      iconSize: Size(16.w, 18.h),
                    )
                  ]
                ],
              ),
            ));
      },
    );
