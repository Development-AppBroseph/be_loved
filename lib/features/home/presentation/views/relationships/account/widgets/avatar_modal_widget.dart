import 'dart:io';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/auth/presentation/views/image/avatar.dart';
import 'package:be_loved/features/home/presentation/views/relationships/account/widgets/dialog_card.dart';
import 'package:be_loved/features/home/presentation/views/relationships/account/widgets/image_change_popup.dart';
import 'package:be_loved/features/profile/presentation/widget/grey_line_for_bottomsheet.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'mirror_image.dart';

class AvatarModalWidget extends StatefulWidget {
  final Function(File? file, bool isMirror) onTap;
  final File? currentImage; 
  const AvatarModalWidget({Key? key, required this.onTap, required this.currentImage}) : super(key: key);

  @override
  State<AvatarModalWidget> createState() => _AvatarModalWidgetState();
}

class _AvatarModalWidgetState extends State<AvatarModalWidget> {
  File? _image;
  bool isMirror = false;
  final CustomPopupMenuController _customPopupMenuController = CustomPopupMenuController();

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image != null) {
        File? img = File(image.path);
        setState(() {
          _image = img;
        });
        _customPopupMenuController.hideMenu();
      }
    } on PlatformException catch (e) {
      print(e);
      _customPopupMenuController.hideMenu();
    }
  }

  void mirror() {
    setState(() {
      !isMirror ? isMirror = true : isMirror = false;
      _customPopupMenuController.hideMenu();
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _image = widget.currentImage;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoCard(
      radius: BorderRadius.vertical(
        top: Radius.circular(80.r),
      ),
      elevation: 0,
      margin: EdgeInsets.zero,
      child: SizedBox(
        height: 750.h,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Container(
                width: 100.w,
                height: 5.h,
                margin: EdgeInsets.only(top: 7.h, bottom: 10.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: ColorStyles.greyColor,
                ),
              ),
              Text(
                'Редактировать аватарку',
                style: TextStyles(context).grey_15_w800,
              ),
              
              SizedBox(height: 27.h,),
              CustomPopupMenu(
                position: PreferredPosition.bottom,
                barrierColor: Colors.transparent,
                showArrow: false,
                controller:
                    _customPopupMenuController,
                pressType: PressType.singleClick,
                child: MirrorImage(
                  isMirror: isMirror,
                  path: _image,
                ),
                verticalMargin: 14.h,
                menuBuilder: () {
                  return ImageChangePopup(
                    mirror: mirror, 
                    pickImage: _pickImage
                  );
                },
              ),
              
              SizedBox(height: 38.h-MediaQuery.of(context).padding.top,),
              SafeArea(
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  width: 378.w,
                  height: 307.w,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(228, 228, 228, 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AvatarMenu(),
                ),
              ),
              SizedBox(height: 53.h),
              SizedBox(
                width: 377.w,
                child: CustomButton(
                  color: ColorStyles.accentColor,
                  text: 'Готово',
                  validate: true,
                  code: false,
                  textColor: Colors.white,
                  onPressed: (){
                    widget.onTap(
                      _image,
                      isMirror
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 30.h,),
            ],
          ),
        ),
      ),
    );
  }
}
