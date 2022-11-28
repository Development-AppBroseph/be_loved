import 'dart:io';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class MirrorImage extends StatelessWidget {
  final File? path;
  final String? urlToImage;
  final bool isBorder;
  MirrorImage({this.path, this.urlToImage, this.isBorder = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165.h,
      height: 165.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(48.r),
        ),
        boxShadow:isBorder
        ? const [
          BoxShadow(
            color: Colors.white, 
            offset: Offset(0, 1)
          )
        ] : [],
        border: isBorder
        ? Border.all(width: 5.h, color: Colors.white)
        : null,
        image: path != null
            ? DecorationImage(
                image: FileImage(path!),
                fit: BoxFit.cover,
              )
            : urlToImage != null 
            ? DecorationImage(
                image: NetworkImage(Config.url.url + urlToImage!),
                fit: BoxFit.cover,
              )
            : const DecorationImage(
                image: AssetImage(Img.avatarNone),
                fit: BoxFit.cover,
              )
      ),
      child: path == null && urlToImage != null
      ? ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(50.r),
        ),
        child: CachedNetworkImage(
          imageUrl: Config.url.url + urlToImage!,
          fit: BoxFit.cover,
          fadeInCurve: Curves.easeInOutQuint,
          fadeOutCurve: Curves.easeInOutQuint,
          fadeInDuration: const Duration(milliseconds: 300),
          fadeOutDuration: const Duration(milliseconds: 300),
        ),
      )
      : null
    );
  }
}