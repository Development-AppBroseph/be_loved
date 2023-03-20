import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';



class MomentsPhotoCard extends StatelessWidget {
  final GlobalKey? additionKey;
  final Function() onAdditionTap;
  final Function(GlobalKey? g)? onAdditionWithKeyTap;
  final Function() onTap;
  final String url;
  final String? title;
  final double? height;
  final bool? isFavorite;
  final bool isFavoriteVal;
  final bool isVideo;
  final Function()? onFavoriteTap;

  const MomentsPhotoCard({
    required this.additionKey,
    this.height,
    required this.onAdditionTap,
    this.onAdditionWithKeyTap,
    required this.onTap,
    required this.url,
    this.isFavorite, 
    this.isVideo = false,
    this.onFavoriteTap,
    this.isFavoriteVal = false,
    this.title
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CupertinoCard(
        elevation: 0,
        margin: EdgeInsets.zero,
        radius: BorderRadius.circular(60.r),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: url,
              height: height ?? 378.w,
              width: 378.w,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorStyles.blackColor.withOpacity(0.6-0.1),
                      ColorStyles.blackColor.withOpacity(0),
                    ]
                  )
                ),
              )
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: 0.8,
                    colors: [
                      ColorStyles.blackColor.withOpacity(0),
                      ColorStyles.blackColor.withOpacity(0.3-0.1),
                    ]
                  )
                ),
              )
            ),
            Positioned(
              top: 21.h,
              left: 24.w,
              right: 24.w,
              child: Text(
                title ?? '', 
                style: TextStyles(context).white_25_w800.copyWith(color: title == null ? Colors.white : Colors.white.withOpacity(0.5)),
              )
            ),
            Positioned(
              bottom: 30.h,
              right: 24.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if(isFavorite != null)
                  GestureDetector(
                    onTap: onFavoriteTap,
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      width: 50.w,
                      height: 27,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        isFavoriteVal ? SvgImg.favoriteFilled : SvgImg.favorite,
                        height: 22.5.h,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),





            if(isVideo)
            Positioned.fill(
              child: Center(child: SvgPicture.asset(SvgImg.play, ))
            ),
          ],
        ),
      ),
    );
  }
}