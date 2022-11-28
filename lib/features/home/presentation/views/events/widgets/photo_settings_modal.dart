import 'dart:io';
import 'dart:ui';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/settings_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';


void photoSettingsModal(
  BuildContext context,
  Offset offset,
  bool isEditPhoto,
  Function() onDelete,
  Function(File f) onSetPhoto,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        bool isEditing = false;
        return AlertDialog(
          insetPadding: EdgeInsets.only(top: offset.dy+(isEditPhoto ? 25.h : 35.h), left: offset.dx - (isEditPhoto ? 177.h : 210.h)),
          alignment: Alignment.topLeft,
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconColor: Colors.transparent,
          content: StatefulBuilder(builder: ((context, setState) {
            return SizedBox(
              height: 220.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: !isEditPhoto || isEditing
                ? [
                  if(isEditPhoto)
                  ...[
                    Container(
                      width: 241.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(17.r),
                          topRight: Radius.circular(17.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20.w,
                            offset: Offset(0, 5.h)
                          )
                        ]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(17.r),
                          topRight: Radius.circular(17.r),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(
                            color: Colors.white.withOpacity(0.9),
                            alignment: Alignment.center,
                            child: Text('Редактировать', style: TextStyles(context).black_15_w700.copyWith(color: ColorStyles.greyColor),)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h,),
                  ],

                  SettingsItem(
                    onTap: () async{
                      var result = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                      );
                      if (result != null) {
                        onSetPhoto(File(result.path));
                      }
                    },  
                    text: 'Сделать фото',
                    iconSize: Size(20.w, 18.h),
                    icon: SvgImg.camera,
                    borderRadius: isEditPhoto
                    ? BorderRadius.zero
                    : null,
                  ),
                  SizedBox(height: 5.h,),
                  SettingsItem(
                    onTap: () async{
                      var result = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (result != null) {
                        onSetPhoto(File(result.path));
                      }
                    },  
                    text: 'Из галереи',
                    iconSize: Size(20.w, 20.h),
                    icon: SvgImg.gallery,
                    borderRadius: BorderRadius.zero,
                  ),
                  SizedBox(height: 5.h,),
                  SettingsItem(
                    onTap: (){
                    },  
                    text: 'Из архива',
                    iconSize: Size(20.w, 22.h),
                    icon: SvgImg.archive,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(17.r),
                      bottomRight: Radius.circular(17.r),
                    ),
                  ),
                ]
                : [
                  SettingsItem(
                    onTap: (){
                      setState((){
                        isEditing = true;
                      });
                    },  
                    text: 'Редактировать',
                    icon: SvgImg.edit,
                  ),
                  SizedBox(height: 5.h,),
                  SettingsItem(
                    onTap: (){
                      onDelete();
                    },
                    text: 'Удалить фото',
                    icon: SvgImg.trash,
                    color: ColorStyles.redColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(17.r),
                      bottomRight: Radius.circular(17.r),
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
