import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/helpers/widget_position_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_group_files_entity.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/helpers/gallery_helper.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/archive_wrapper.dart';
import 'package:be_loved/features/home/presentation/views/bottom_navigation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DetailGalleryPage extends StatefulWidget {
  GalleryGroupFilesEntity group;
  DetailGalleryPage({required this.group});
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
      body: Container(
        child: GestureDetector(
          onHorizontalDragUpdate:(details) {
            print('DiR: ${details.delta.direction}');
            if(details.delta.direction <= 0){
              Navigator.pop(context);
            }
          },
          child: ArchiveWrapper(
            currentIndex: 1,
            scrollController: ScrollController(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Wrap(
                    spacing: 4.w,
                    runSpacing: 4.w,
                    children: List.generate(widget.group.additionalFiles.length + 1 + (widget.group.mainVideo == null ? 0 : 1), (index)
                      => index == 0 
                      ? GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Stack(
                          children: [
                            Hero(tag: '#${widget.group.mainPhoto.id}', child: _buildMiniItem(
                              widget.group.mainPhoto
                            )),
                            Container(
                              width: 140.w,
                              height: 70.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFF2C2C2E).withOpacity(0.5),
                                    Color(0xFF2C2C2E).withOpacity(0),
                                  ]
                                )
                              ),
                            ),
                            Positioned(
                              top: 12.h,
                              left: 12.h,
                              child: Text(convertToRangeDates(widget.group), style: TextStyles(context).white_18_w800.copyWith(color: Colors.white.withOpacity(0.7)),)
                            ),
                            
                          ],
                        ),
                      )
                      : _buildMiniItem(
                        index == 1 && widget.group.mainVideo != null
                        ? widget.group.mainVideo!
                        : widget.group.additionalFiles[index - 1 + (widget.group.mainVideo == null ? 0 : 1)]
                      )
                    )
                  ),
                  SizedBox(height: 400.h,)
                ],
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
      ),
    );
  }





  _buildMiniItem(GalleryFileEntity file){
    return Container(
      height: 140.h,
      width: 140.w,
      color: ColorStyles.greyColor2,
      child: CachedNetworkImage(
        imageUrl: file.urlToFile,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      )
    );
  }
}
