import 'dart:io';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/utils/helpers/date_time_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/domain/entities/purposes/purpose_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';


class PurposeCard extends StatelessWidget {
  final PurposeEntity purposeEntity;
  final Function()? onCompleteTap;
  final Function(File file)? onPickFile;
  PurposeCard({required this.purposeEntity, this.onCompleteTap, this.onPickFile});


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
      height: 250.h,
      child: CupertinoCard(
        margin: EdgeInsets.zero,
        elevation: 0,
        radius: BorderRadius.circular(40.r),
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
                  height: 151.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                if(purposeEntity.dateTime != null && daysDifference.inDays <= 31)
                Positioned(
                  top: 18.h,
                  left: 20.w,
                  child: CupertinoCard(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 8.h),
                    color: Color(0xFFABABAC).withOpacity(0.7),
                    radius: BorderRadius.circular(20.r),
                    child: Text(
                      daysDifference == 0
                      ? purposeTimes(daysDifference)
                      : purposeDays('${daysDifference.inDays}'), 
                    style: TextStyles(context).black_15_w800.copyWith(color: ColorStyles.blackColor.withOpacity(0.7)),),
                  ),
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
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(purposeEntity.name, style: TextStyles(context).black_25_w800,),
                    ),
                    SizedBox(width: 4.w,),

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
                          child: Center(child: Text('Достигнуть', style: TextStyles(context).white_18_w800,)),
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
            )
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
          child: Center(child: SvgPicture.asset(svg, width: 19.w, color: Colors.white,)),
        ),
      ),
    );
  }
}