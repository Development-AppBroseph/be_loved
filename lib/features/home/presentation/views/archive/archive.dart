import 'dart:ui';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_group_files_entity.dart';
import 'package:be_loved/features/home/presentation/views/archive/gallery_page.dart';
import 'package:be_loved/features/home/presentation/views/archive/helpers/gallery_helper.dart';
import 'package:be_loved/features/home/presentation/views/archive/widgets/archive_wrapper.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class ArchivePage extends StatefulWidget {
  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {

  ScrollController scrollController = ScrollController();
  bool showTop = false;
  GalleryGroupFilesEntity? enitityPos;
  String dateTime = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // scrollController.addListener(() {
    //   double position = scrollController.position.pixels;
    //   bool newVal = false;
    //   if(position > 170){
    //     newVal = true;
    //   }else{
    //     newVal = false;
    //   }
    //   if(showTopImage != newVal){
    //     setState(() {
    //       showTopImage = newVal;
    //     });
    //   }
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ArchiveWrapper(
          child: GalleryPage(
            scrollController: scrollController,
            onChangeShow: (show) {
              setState(() {
                if(show != null){
                  dateTime = convertToRangeDates(show);
                  showTop = true;
                  enitityPos = show;
                }else{
                  showTop = false;
                }
              });
            },
          ),
          scrollController: scrollController,
        ),
        Positioned(
            top: MediaQuery.of(context).padding.top+15.h,
            left: 30.w,
            right: 22.w,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOutQuint,
              margin: EdgeInsets.only(top: showTop ? 10.h : 20.h),
              child: AnimatedOpacity(
                opacity: showTop ? 1 : 0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOutQuint,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(dateTime, style: TextStyles(context).white_35_w800.copyWith(color: Colors.white.withOpacity(0.7),)),
                        SizedBox(
                          width: 120.w,
                          height: 38.h,
                          child: ClipPath.shape(
                            shape: SquircleBorder(
                              radius: BorderRadius.circular(30.r)
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                              child: Container(
                                color: Colors.white.withOpacity(0.7),
                                alignment: Alignment.center,
                                child: Text('Выбрать', style: TextStyles(context).black_18_w800.copyWith(color: ColorStyles.blackColor.withOpacity(0.7)),)
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Text(enitityPos == null ? '' : enitityPos!.mainPhoto.place, style: TextStyles(context).white_15_w800.copyWith(color: Colors.white.withOpacity(0.5),)),
                  ],
                ),
              ),
            )
          )
      ],
    );
  }
}
