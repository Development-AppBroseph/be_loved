import 'dart:ui';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_group_files_entity.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ArchiveFixedTopInfo extends StatelessWidget {
  final bool showTop;
  final GalleryGroupFilesEntity? enitityPos;
  final String dateTime;
  final bool isDeleting;
  final Function() onTap;
  final Function() onDeleteTap;
  final Function()? onBackTap;
  final bool isForSelecting;
  const ArchiveFixedTopInfo({
    required this.showTop,
    required this.enitityPos,
    required this.onDeleteTap,
    required this.onTap,
    this.isForSelecting = false,
    this.onBackTap,
    required this.dateTime,
    required this.isDeleting,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutQuint,
      margin: EdgeInsets.only(top: showTop ? 10.h : 20.h),
      child: AnimatedOpacity(
        opacity: isForSelecting || showTop ? 1 : 0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutQuint,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isForSelecting)
                  GestureDetector(
                    onTap: onBackTap,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      color: Colors.transparent,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            SvgImg.back,
                            height: 26.32.h,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Text(
                            'Назад',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 20.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Text(
                    dateTime,
                    style: TextStyles(context).white_35_w800.copyWith(
                          color: Colors.white.withOpacity(0.7),
                        ),
                  ),
                if (showTop)
                  isDeleting
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildSelectBtn('Отменить', context),
                            if (!isForSelecting) ...[
                              SizedBox(
                                width: 10.w,
                              ),
                              _buildDeleteBtn()
                            ]
                          ],
                        )
                      : _buildSelectBtn('Выбрать', context),
              ],
            ),
            if (!isForSelecting)
              Text(
                enitityPos == null ? '' : (enitityPos!.mainPhoto.place ?? ''),
                style: TextStyles(context).white_15_w800.copyWith(
                      color: Colors.white.withOpacity(0.5),
                    ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectBtn(String text, BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 120.w,
        height: 38.h,
        child: ClipPath.shape(
          shape: SquircleBorder(radius: BorderRadius.circular(26.r)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.white.withOpacity(0.7),
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyles(context)
                    .black_18_w800
                    .copyWith(color: ColorStyles.blackColor.withOpacity(0.7)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteBtn() {
    return GestureDetector(
      onTap: onDeleteTap,
      child: SizedBox(
        width: 38.h,
        height: 38.h,
        child: ClipPath.shape(
          shape: SquircleBorder(radius: BorderRadius.circular(26.r)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
                color: Colors.white.withOpacity(0.7),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  SvgImg.trash,
                  color: ColorStyles.blackColor.withOpacity(0.6),
                  width: 16.h,
                )),
          ),
        ),
      ),
    );
  }
}
