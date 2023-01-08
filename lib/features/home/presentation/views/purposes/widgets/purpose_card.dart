import 'dart:io';
import 'dart:math';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/utils/helpers/date_time_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';


class PurposeCard extends StatelessWidget {
  final PurposeEntity purposeEntity;
  final Function()? onCompleteTap;
  final Function()? onCancelTap;
  final Function(File file)? onPickFile;
  PurposeCard({required this.purposeEntity, this.onCompleteTap, this.onPickFile, this.onCancelTap});


  pickImage(ImageSource source) async{
    XFile? pick = await ImagePicker().pickImage(source: source);
    if(pick != null){
      if(onPickFile != null)
        onPickFile!(File(pick.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    Duration daysDifference = purposeEntity.dateTime == null ? Duration.zero : purposeEntity.dateTime!.difference(DateTime.now());
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -5.h),
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20.w
          )
        ],
        borderRadius: BorderRadius.circular(20.r)
      ),
      width: 378.w,
      child: CupertinoCard(
        margin: EdgeInsets.zero,
        elevation: 0,
        radius: BorderRadius.circular(40.r),
        color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
        child: Column(
          children: [
            Stack(
              children: [
                // Image.asset(
                //   'assets/images/purpose1.png',
                //   width: double.infinity,
                //   height: 151.h,
                //   fit: BoxFit.cover,
                // ),
                CachedNetworkImage(
                  imageUrl: purposeEntity.photo.contains('http') ? purposeEntity.photo : Config.url.url + purposeEntity.photo,
                  height: purposeEntity.inHistory ? 181.h : 151.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                if((purposeEntity.dateTime != null && daysDifference.inDays <= 31) || purposeEntity.inHistory || purposeEntity.inProcess)
                Positioned(
                  top: 18.h,
                  left: 20.w,
                  child: Row(
                    children: [
                      if(purposeEntity.inProcess)
                      ...[_buildCloseBtn((){onCancelTap != null ? onCancelTap!() : (){};}),
                      SizedBox(width: 10.w,)],
                      _buildStatusBlock(
                        purposeEntity.inProcess
                          ? 'В процессе'
                          : purposeEntity.inHistory
                          ? 'Достигнута'
                          : daysDifference == 0
                          ? purposeTimes(daysDifference)
                          : purposeDays('${daysDifference.inDays}'),
                        context,
                        horizontalPadding: purposeEntity.inProcess ? 26.w : 17.w
                      ),
                    ],
                  )
                ),
                // Positioned(
                //   top: 18.h,
                //   right: 23.w,
                //   child: CupertinoCard(
                //     margin: EdgeInsets.zero,
                //     elevation: 0,
                //     padding: EdgeInsets.symmetric(horizontal: 11.5.w, vertical: 6.5.h),
                //     color: Color(0xFFABABAC).withOpacity(0.7),
                //     radius: BorderRadius.circular(20.r),
                //     child: Text('+50', style: TextStyles(context).black_15_w800.copyWith(color: ColorStyles.blackColor.withOpacity(0.7)),),
                //   ),
                // )
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 23.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text((purposeEntity.name), style: TextStyles(context).black_25_w800,),
                  ),
                  SizedBox(width: 4.w,),
                  if(!purposeEntity.inHistory)
                  !purposeEntity.inProcess
                  ? GestureDetector(
                    onTap: (){
                      if(onCompleteTap != null){
                        onCompleteTap!();
                      }
                    },
                    child: SizedBox(
                      width: 139.w,
                      height: 42.h,
                      child: CupertinoCard(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        color: ColorStyles.primarySwath,
                        radius: BorderRadius.circular(20.r),
                        child: Center(child: Text('Достигнуть', style: TextStyles(context).white_18_w800.copyWith(color: sl<AuthConfig>().idx == 1 ? ColorStyles.black2Color : null))),
                      ),
                    ),
                  )
                  : Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(width: 5.w,),
                      _buildSvgBtn(
                        svg: SvgImg.gallery,
                        onTap: (){
                          pickImage(ImageSource.gallery);
                        }
                      ),
                      SizedBox(width: 24.w,),
                      _buildSvgBtn(
                        svg: SvgImg.camera,
                        onTap: (){
                          pickImage(ImageSource.camera);
                        }
                      ),
                      SizedBox(width: 12.w,)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSvgBtn({required Function() onTap, required String svg}){
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 42.h,
        height: 42.h,
        child: CupertinoCard(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: ColorStyles.primarySwath,
          radius: BorderRadius.circular(20.r),
          child: Center(child: SvgPicture.asset(svg, width: 19.w, color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],)),
        ),
      ),
    );
  }






  Widget _buildStatusBlock(String text, BuildContext context, {double? horizontalPadding}){
    return ClipPath.shape(
      shape: SquircleBorder(
        radius: BorderRadius.circular(20.r)
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 17.w),
            height: 33.h,
            alignment: Alignment.center,
            color: sl<AuthConfig>().idx == 0 ? Colors.white.withOpacity(0.9) : ColorStyles.black2Color.withOpacity(0.9),
            child: Text(
              text, 
            style: TextStyles(context).black_15_w800.copyWith(color: sl<AuthConfig>().idx == 0 ? ColorStyles.blackColor.withOpacity(0.7) : ColorStyles.white.withOpacity(0.7)),),
          )
        ],
      )
    );
  }



  Widget _buildCloseBtn(Function() onTap){
    return GestureDetector(
      onTap: onTap,
      child: ClipPath.shape(
        shape: SquircleBorder(
          radius: BorderRadius.circular(20.r)
        ),
        child: Container(
          height: 33.h,
          color: sl<AuthConfig>().idx == 0 ? Colors.white.withOpacity(0.9) : ColorStyles.black2Color.withOpacity(0.9),
          width: 33.h,
          child: Stack(
            children: [
              Center(
                child: SvgPicture.asset(SvgImg.add, height: 14.h, color: sl<AuthConfig>().idx == 0 ? ColorStyles.blackColor.withOpacity(0.7) : ColorStyles.white.withOpacity(0.7),)
              )
            ],
          ),
        )
      ),
    );
  }
}