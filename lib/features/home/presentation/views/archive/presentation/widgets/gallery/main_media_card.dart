import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_group_files_entity.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/helpers/gallery_helper.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/gallery/selected_check.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/gallery/video_file_image.dart';
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
  final bool isForSelecting;
  final Key dotsKey;
  final Function() onDotsTap;
  final Function() onTapBottom;
  final Function() onTapTop;
  final Function() onLongTap;
  MainMediaCard(
      {required this.file,
      required this.isForSelecting,
      required this.mainKey,
      required this.onLongTap,
      required this.dotsKey,
      required this.onDotsTap,
      required this.group,
      required this.onTapTop,
      required this.onTapBottom,
      required this.showTopBar,
      required this.isDeleting});

  @override
  Widget build(BuildContext context) {
    double height = file.isVideo ? 284.h : 428.w;
    return GestureDetector(
      key: mainKey,
      child: Padding(
        padding: EdgeInsets.only(
            top: group.mainVideo != null && group.mainVideo!.id == file.id
                ? 0
                : 4.w),
        child: Stack(
          children: [
            Hero(
                tag: '#${file.id}',
                child:
                    // file.isVideo
                    // ? VideoFileImage(file: file)
                    // :
                    CachedNetworkImage(
                  imageUrl: file.isVideo
                      ? (file.urlToPreviewVideoImage ?? '')
                      : file.urlToFile,
                  height: height,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
                // Image.asset(
                //   'assets/images/gallery1.png',
                //   fit: BoxFit.cover,
                //   width: double.infinity,
                //   height: height,
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
                  ])),
            ),
            if (isDeleting)
              Container(
                width: double.infinity,
                height: height,
                color: Colors.white.withOpacity(0.3),
              ),
            if (isDeleting) SelectedCheck(),
            if (showTopBar &&
                file.id == group.mainPhoto.id &&
                !isForSelecting) //&& !file.isVideo)
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
                          Text(
                            convertToRangeDates(group),
                            style: TextStyles(context).white_35_w800.copyWith(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                          ),
                          if (!file.isVideo)
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: onDotsTap,
                              child: SizedBox(
                                height: 40.h,
                                width: 50.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SvgPicture.asset(
                                      SvgImg.dots,
                                      height: 7.h,
                                      color: Colors.white,
                                      key: dotsKey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      // Text(file.place ?? '',
                      //     style: TextStyles(context).white_15_w800.copyWith(
                      //           color: Colors.white.withOpacity(0.7),
                      //         )),
                    ],
                    // ),
                  )),
            if (file.isVideo)
              Positioned.fill(
                  child: Center(
                      child: SvgPicture.asset(
                SvgImg.play,
              ))),
            if (file.isVideo && file.duration != null)
              Positioned(
                  top: 30.h,
                  right: 30.w,
                  child: Text(formatDuration(Duration(seconds: file.duration!)),
                      style: TextStyles(context).white_15_w800)),
            Positioned.fill(
              bottom: height * 0.6,
              top: 0,
              child: GestureDetector(
                onLongPress: onLongTap,
                onTap: onTapTop,
                behavior: HitTestBehavior.opaque,
              ),
            ),
            Positioned.fill(
              bottom: 0,
              top: height * 0.4,
              child: GestureDetector(
                onLongPress: onLongTap,
                onTap: onTapBottom,
                behavior: HitTestBehavior.opaque,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatDuration(Duration duration) {
  String hours = duration.inHours.toString().padLeft(0, '2');
  String minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  String seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return "${hours == '0' ? '' : '$hours:'}${minutes[0] == '0' ? minutes.substring(1) : minutes}:$seconds";
}
