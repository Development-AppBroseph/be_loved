import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_group_files_entity.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/helpers/gallery_helper.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/gallery/selected_check.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';


class MainMediaCard extends StatelessWidget {
  final GalleryFileEntity file;
  final GalleryGroupFilesEntity group;
  final Key mainKey;
  final bool showTopBar;
  final bool isDeleting;
  final Key dotsKey;
  final Function() onDotsTap;
  final Function() onTap;
  MainMediaCard({
    required this.file,
    required this.mainKey,
    required this.dotsKey,
    required this.onDotsTap,
    required this.group,
    required this.onTap,
    required this.showTopBar,
    required this.isDeleting
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      key: mainKey,
      child: Padding(
        padding: EdgeInsets.only(top: 4.w),
        child: Stack(
          children: [
            Hero(
              tag: '#${file.id}',
              child: CachedNetworkImage(
                imageUrl: file.urlToFile,
                height: 428.w,
                width: double.infinity,
                fit: BoxFit.cover,
              )
              // Image.asset(
              //   'assets/images/gallery1.png', 
              //   fit: BoxFit.cover,
              //   width: double.infinity,
              //   height: 428.w,  
              // )
            ),
            Container(
              width: double.infinity,
              height: 151.h,
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
            if(isDeleting)
            Container(
              width: double.infinity,
              height: 428.w,
              color: Colors.white.withOpacity(0.3),
            ),
            if(isDeleting)
            SelectedCheck(),
            if(showTopBar)
            Positioned(
              top: 25.h,
              left: 30.w,
              right: 40.w,
              // child: AnimatedOpacity(
                // opacity: file.id != hideGalleryFileID ? 1 : 0,
                // duration: const Duration(milliseconds: 800),
                // curve: Curves.easeInOutQuint,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(convertToRangeDates(group), style: TextStyles(context).white_35_w800.copyWith(color: Colors.white.withOpacity(0.7),)),
                        GestureDetector(
                          onTap: onDotsTap,
                          child: SvgPicture.asset(
                            SvgImg.dots,
                            height: 7.h,
                            color: Colors.white,
                            key: dotsKey,
                          ),
                        ),
                      ],
                    ),
                    Text(file.place ?? '', style: TextStyles(context).white_15_w800.copyWith(color: Colors.white.withOpacity(0.7),)),
                  ],
                // ),
              )
            ),
          ],
        ),
      ),
    );
  }
}