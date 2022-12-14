import 'dart:async';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/helpers/widget_position_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/presentation/views/archive/detail_gallery.dart';
import 'package:be_loved/features/home/presentation/views/archive/widgets/archive_wrapper.dart';
import 'package:be_loved/features/home/presentation/views/archive/widgets/gallery_settings_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ArchivePage extends StatefulWidget {
  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {

  @override
  Widget build(BuildContext context) {
    return ArchiveWrapper(child: _buildMainList());
  }

  showGallerySettingsModal(Offset offset){
    gallerySettingsModal(
      context, 
      offset,
      (){},
      (){}
    );
  }




  Widget _buildMainList(){

    return SingleChildScrollView(
      child: Wrap(
        spacing: 4.w,
        runSpacing: 4.w,
        children: List.generate(20, 
          (index) => index % 5 == 0
          ? _buildMainItem(GlobalKey(), index)
          : index != 0 && (index-1) % 5 == 0
          ? _buildVideoItem()
          : _buildMiniItem()
        ),
      ),
    );
    
    
    // ListView.builder(
    //   padding: EdgeInsets.zero,
    //     physics: const BouncingScrollPhysics(),
    //     shrinkWrap: true,
    //     itemBuilder: ((context, index) {
    //       if (index % 4 == 0) {
    //         GlobalKey newKey = GlobalKey();
    //         return GestureDetector(
    //           onTap: (){
    //             Navigator.of(context).push(
    //               PageRouteBuilder(
    //                 pageBuilder: (_, __, ___) => DetailGalleryPage(index: index),
    //                 transitionDuration: Duration(milliseconds: 400),
    //                 transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
    //             ));
    //           },
    //           child: Padding(
    //             padding: EdgeInsets.only(bottom: 4.h),
    //             child: Stack(
    //               children: [
    //                 Hero(
    //                   tag: '#${index}',
    //                   child: Image.asset('assets/images/gallery1.png', fit: BoxFit.cover,)
    //                 ),
    //                 Positioned(
    //                   top: 25.h,
    //                   left: 30.w,
    //                   right: 40.w,
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Row(
    //                         crossAxisAlignment: CrossAxisAlignment.center,
    //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                         children: [
    //                           Text('28.11.2021', style: TextStyles(context).white_35_w800.copyWith(color: Colors.white.withOpacity(0.5),)),
    //                           GestureDetector(
    //                             onTap: (){
    //                               showGallerySettingsModal(getWidgetPosition(newKey));
    //                             },
    //                             child: SvgPicture.asset(
    //                               SvgImg.dots,
    //                               height: 7.h,
    //                               color: Colors.white,
    //                               key: newKey,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                       Text('г.Санкт-Петербург', style: TextStyles(context).white_15_w800.copyWith(color: Colors.white.withOpacity(0.5),)),
    //                     ],
    //                   )
    //                 )
    //               ],
    //             ),
    //           ),
    //         );
    //       } else if(index != 0 && (index-1) % 4 == 0){
    //         return Padding(
    //           padding: EdgeInsets.only(bottom: 4.h),
    //           child: Stack(
    //             children: [
    //               Container(
    //                 height: 284.h,
    //                 color: ColorStyles.greyColor2,
    //                 child: Image.asset('assets/images/gallery2.png', fit: BoxFit.cover,),
    //               ),
    //               Positioned.fill(
    //                 child: Center(child: SvgPicture.asset(SvgImg.play, ))
    //               ),
    //               Positioned(
    //                 top: 30.h,
    //                 right: 30.w,
    //                 child: Text('0:40', style: TextStyles(context).white_15_w800)
    //               )
    //             ],
    //           ),
    //         );
    //       } else {
    //         return Padding(
    //           padding: EdgeInsets.only(bottom: 4.h),
    //           child: Row(
    //             children: [
    //               Container(
    //                 height: 140.h,
    //                 width: 140.w,
    //                 color: ColorStyles.greyColor2,
    //                 child: Image.asset('assets/images/gallery3.png', fit: BoxFit.cover,),
    //               ),
    //               SizedBox(width: 4.w),
    //               Container(
    //                 height: 140.h,
    //                 width: 140.w,
    //                 color: ColorStyles.greyColor2,
    //                 child: Image.asset('assets/images/gallery4.png', fit: BoxFit.cover,),
    //               ),
    //               SizedBox(width: 4.w),
    //               Container(
    //                 height: 140.h,
    //                 width: 140.w,
    //                 color: ColorStyles.greyColor2,
    //                 child: Image.asset('assets/images/gallery5.png', fit: BoxFit.cover,),
    //               ),
    //             ],
    //           ),
    //         );
    //       }
    //     }),
    //     itemCount: 20);
  }




  Widget _buildVideoItem(){
    return Stack(
      children: [
        Container(
          height: 284.h,
          color: ColorStyles.greyColor2,
          child: Image.asset('assets/images/gallery2.png', fit: BoxFit.cover,),
        ),
        Positioned.fill(
          child: Center(child: SvgPicture.asset(SvgImg.play, ))
        ),
        Positioned(
          top: 30.h,
          right: 30.w,
          child: Text('0:40', style: TextStyles(context).white_15_w800)
        )
      ],
    );
  }


  Widget _buildMainItem(GlobalKey newKey, int index){
    print('IND: ${index}');
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => DetailGalleryPage(index: index),
            transitionDuration: Duration(milliseconds: 400),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        ));
      },
      child: Stack(
        children: [
          Hero(
            tag: '#${index}',
            child: Image.asset(
              'assets/images/gallery1.png', 
              fit: BoxFit.cover,
              width: double.infinity,
              height: 428.w,  
            )
          ),
          Positioned(
            top: 25.h,
            left: 30.w,
            right: 40.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('28.11.2021', style: TextStyles(context).white_35_w800.copyWith(color: Colors.white.withOpacity(0.5),)),
                    GestureDetector(
                      onTap: (){
                        showGallerySettingsModal(getWidgetPosition(newKey));
                      },
                      child: SvgPicture.asset(
                        SvgImg.dots,
                        height: 7.h,
                        color: Colors.white,
                        key: newKey,
                      ),
                    ),
                  ],
                ),
                Text('г.Санкт-Петербург', style: TextStyles(context).white_15_w800.copyWith(color: Colors.white.withOpacity(0.5),)),
              ],
            )
          )
        ],
      ),
    );
  }







  _buildMiniItem(){
    return Container(
      height: 140.h,
      width: 140.w,
      color: ColorStyles.greyColor2,
      child: Image.asset('assets/images/gallery5.png', fit: BoxFit.cover,),
    );
  }

}
