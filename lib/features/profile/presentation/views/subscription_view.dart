import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/custom_animation_button.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/send_file/send_file_modal.dart';
import 'package:be_loved/features/profile/presentation/views/parting_second_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';



class SubscriptionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/back.png',
            width: MediaQuery.of(context,).size.width,
            height: 690.h,
            fit: BoxFit.cover,
          ),
          SizedBox(height: MediaQuery.of(context).size.height,),
          Positioned(
            bottom: 0,
            child: Container(
              height: 530.h,
              width: MediaQuery.of(context,).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    Colors.black,
                    Colors.black.withOpacity(0),
                  ]
                )
              ),
            ),
          ),
          Positioned.fill(
            top: 595.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Поддержи проект',
                  style: TextStyles(context).white_35_w800,
                ),
                SizedBox(height: 15.h,),
                Text(
                  'И получи N ГБ совместного архива, доступ к\nвыполнению уникальных целей и получению\nинтересных призов :) ', 
                  style: TextStyles(context).grey_15_w800,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: CustomButton(
                    color: ColorStyles.white,
                    text: 'Приобрести за 200₽',
                    textColor: ColorStyles.blackColor,
                    validate: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: 15.h,),
                Text(
                  'Пользовательское соглашение',
                  style: TextStyles(context).grey_15_w800,
                ),
              ],
            )
          ),

          Positioned(
            top: 38.h + MediaQuery.of(context).padding.top,
            left: 35.w,
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    SvgImg.back,
                    height: 26.32.h,
                    color: Colors.white,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20.w),
                    child: Text(
                      'Назад',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}