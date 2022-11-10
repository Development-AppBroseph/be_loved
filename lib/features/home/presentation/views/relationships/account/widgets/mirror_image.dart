import 'dart:io';
import 'package:be_loved/core/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class MirrorImage extends StatelessWidget {
  final bool isMirror;
  final File? path;
  MirrorImage({required this.isMirror, this.path});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      alignment: Alignment.center,
      scaleX: !isMirror ? 1 : -1,
      child: Container(
        width: 165.h,
        height: 165.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(50.r),
          ),
          border: Border.all(width: 5.h, color: Colors.white),
          image: path == null
              ? const DecorationImage(
                  image: AssetImage(Img.avatarNone),
                  fit: BoxFit.cover,
                )
              : DecorationImage(
                  image: FileImage(path!),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}