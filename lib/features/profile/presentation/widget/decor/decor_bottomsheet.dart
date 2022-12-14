import 'dart:math';
import 'dart:ui';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/option_black_btn.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DecorBottomsheet extends StatefulWidget {
  const DecorBottomsheet({Key? key}) : super(key: key);

  @override
  State<DecorBottomsheet> createState() => _DecorBottomsheetState();
}

class _DecorBottomsheetState extends State<DecorBottomsheet> {

  bool isSelectBackground = true;

  List<String> backgorunds = [
    'assets/images/gallery1.png',
    'assets/images/gallery1.png',
    'assets/images/gallery1.png',
    'assets/images/gallery1.png',
  ];


  @override
  Widget build(BuildContext context) {
    return CupertinoCard(
      radius: BorderRadius.vertical(
        top: Radius.circular(40.r),
      ),
      elevation: 0,
      margin: EdgeInsets.zero,
      child: SizedBox(
        height: 415.h,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.w, top: 28.h, bottom: 31.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OptionBlackBtn(
                      text: 'Фоновое фото',
                      isSelected: isSelectBackground,
                      onTap: (){
                        setState(() {
                          isSelectBackground = true;
                        });
                      },
                    ),
                    SizedBox(width: 15.w,),
                    OptionBlackBtn(
                      text: 'Тема',
                      isSelected: !isSelectBackground,
                      onTap: (){
                        setState(() {
                          isSelectBackground = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 31.h,
              ),
              if(isSelectBackground)
              _buildBackgroundContent()
              else
              _buildThemeContent(),
              SizedBox(
                height: 60.h,
              ),
            ],
          ),
        ),
      ),
    );
  }






  // Theme content
  Widget _buildThemeContent(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 25.w),
          child: Text('Тема', style: TextStyles(context).black_25_w800,),
        ),
        SizedBox(
          height: 13.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Row(
            children: [
              _buildThemeItem(isDarkTheme: false),
              SizedBox(width: 18.w,),
              _buildThemeItem(isDarkTheme: true, isSelected: true)
            ],
          ),
        )
      ],
    );
  }


  _buildThemeItem({required bool isDarkTheme, bool isSelected = false}){
    return Expanded(
      child: SizedBox(
        height: 150.h,
        child: CupertinoCard(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: ColorStyles.greyColor,
          radius: BorderRadius.circular(40.r),
          child: Stack(
            children: [
              if(!isDarkTheme)
              Positioned.fill(
                child: CupertinoCard(
                  margin: EdgeInsets.all(2.w),
                  elevation: 0, 
                  color: Colors.transparent,
                  radius: BorderRadius.circular(37.r),
                  child: Image.asset(
                    'assets/images/gallery1.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              )
              else
              Image.asset(
                'assets/images/gallery1.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              
              Positioned.fill(
                bottom: isSelected ? 10.h : 20.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isDarkTheme ? 'Темная' : 'Светлая', 
                      style: isDarkTheme
                      ? TextStyles(context).white_18_w800
                      : TextStyles(context).black_18_w800,
                    ),
                    if(isSelected)
                    Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: ClipPath.shape(
                        shape: SquircleBorder(
                          radius: BorderRadius.circular(20.r)
                        ),
                        child: SizedBox(
                          width: 103.w,
                          height: 33.h,
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Container(
                                color: Colors.white.withOpacity(0.7),
                                alignment: Alignment.center,
                                child: Text('Выбрано', style: TextStyles(context).black_15_w800.copyWith(color: ColorStyles.blackColor.withOpacity(0.7)),)
                              ),
                            ),
                          ),
                        )
                      ),
                    )
                  ],
                )
              )
            ],
          )
        ),
      ),
    );
  }



  // Background select content
  Widget _buildBackgroundContent(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 25.w),
          child: Text('Фон', style: TextStyles(context).black_25_w800,),
        ),
        SizedBox(
          height: 13.h,
        ),
        SizedBox(
          height: 150.h,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.w, right: 10.w),
                child: _buildAddItem(),
              ),
              ...backgorunds.map(
                (e) => Container(
                  margin: EdgeInsets.only(right: 10.w),
                  height: 150.h,
                  width: 150.h,
                  child: CupertinoCard(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    color: ColorStyles.greyColor,
                    radius: BorderRadius.circular(40.r),
                    child: Image.asset(
                      e,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  ),
                )
              ).toList()
            ],
          ),
        ),
      ],
    );
  }






  // Background select add widget
  Widget _buildAddItem(){
    return SizedBox(
      height: 150.h,
      width: 75.w,
      child: CupertinoCard(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: ColorStyles.greyColor,
        radius: BorderRadius.circular(40.r),
        child: Stack(
          children: [
            Positioned.fill(
              child: CupertinoCard(
                elevation: 0,
                margin: EdgeInsets.all(1.w),
                radius: BorderRadius.circular(37.r),
                color: Colors.white
              ),
            ),
            Center(
              child: Transform.rotate(
                angle: pi / 4,
                child:
                    SvgPicture.asset(SvgImg.add, height: 20.h,)
              )
            ),



            
          ],
        ),
      ),
    );
  }
}