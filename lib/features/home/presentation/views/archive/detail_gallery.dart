import 'dart:async';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/helpers/widget_position_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/presentation/views/archive/widgets/archive_wrapper.dart';
import 'package:be_loved/features/home/presentation/views/archive/widgets/gallery_settings_modal.dart';
import 'package:be_loved/features/home/presentation/views/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailGalleryPage extends StatefulWidget {
  int index;
  DetailGalleryPage({required this.index});
  @override
  State<DetailGalleryPage> createState() => _DetailGalleryPageState();
}

class _DetailGalleryPageState extends State<DetailGalleryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(
        onTap: () => Navigator.pop(context)
      ),
      backgroundColor: ColorStyles.backgroundColorGrey,
      body: GestureDetector(
        onHorizontalDragUpdate:(details) {
          print('DiR: ${details.delta.direction}');
          if(details.delta.direction <= 0){
            Navigator.pop(context);
          }
        },
        child: ArchiveWrapper(
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 4.w,
              runSpacing: 4.w,
              children: List.generate(60, (index)
                => index == 0 
                ? Hero(tag: '#${widget.index}', child: _buildMiniItem(
                  index % 3 == 0
                  ? 'assets/images/gallery1.png'
                  : index % 2 == 0
                  ? 'assets/images/gallery2.png'
                  : 'assets/images/gallery1.png'
                ))
                : _buildMiniItem(
                  index % 3 == 0
                  ? 'assets/images/gallery3.png'
                  : index % 2 == 0
                  ? 'assets/images/gallery2.png'
                  : 'assets/images/gallery1.png'
                )
              )
            ),
          )
          
          // ListView.builder(
          //   padding: EdgeInsets.zero,
          //     physics: const BouncingScrollPhysics(),
          //     shrinkWrap: true,
          //     itemBuilder: ((context, index) {
          //       return Padding(
          //         padding: EdgeInsets.only(bottom: 4.h),
          //         child: Row(
          //           children: [
          //             if(index == 0)
          //             Hero(
          //               tag: '#${index}',
          //               child: Container(
          //                 height: 140.h,
          //                 width: 140.w,
          //                 color: ColorStyles.greyColor2,
          //                 child: Image.asset(index == 0 ? 'assets/images/gallery1.png' : 'assets/images/gallery3.png', fit: BoxFit.cover,),
          //               ),
          //             ),
          //             if(index != 0)
          //             Container(
          //                 height: 140.h,
          //                 width: 140.w,
          //                 color: ColorStyles.greyColor2,
          //                 child: Image.asset(index == 0 ? 'assets/images/gallery1.png' : 'assets/images/gallery3.png', fit: BoxFit.cover,),
          //               ),
          //             SizedBox(width: 4.w),
          //             Container(
          //               height: 140.h,
          //               width: 140.w,
          //               color: ColorStyles.greyColor2,
          //               child: Image.asset('assets/images/gallery4.png', fit: BoxFit.cover,),
          //             ),
          //             SizedBox(width: 4.w),
          //             Container(
          //               height: 140.h,
          //               width: 140.w,
          //               color: ColorStyles.greyColor2,
          //               child: Image.asset('assets/images/gallery5.png', fit: BoxFit.cover,),
          //             ),
          //           ],
          //         ),
          //       );
          //     }),
          //     itemCount: 20),
        ),
      ),
    );
  }





  _buildMiniItem(String asset){
    return Container(
      height: 140.h,
      width: 140.w,
      color: ColorStyles.greyColor2,
      child: Image.asset(asset, fit: BoxFit.cover,),
    );
  }
}
