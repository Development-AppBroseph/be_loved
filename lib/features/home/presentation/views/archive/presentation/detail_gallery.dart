import 'dart:async';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_group_files_entity.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/helpers/gallery_helper.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/video_view_v2.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/archive_wrapper.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/gallery/mini_media_card.dart';
import 'package:be_loved/features/home/presentation/views/bottom_navigation.dart';
import 'package:be_loved/features/home/presentation/views/events/view/photo_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class DetailGalleryPage extends StatefulWidget {
  GalleryGroupFilesEntity group;
  List<GalleryGroupFilesEntity>? groupList;
  final Function(int i) onPageChange;
  final Function(int id) onSelectForDeleting;
  final List<int> deletingIds;
  DetailGalleryPage(
      {required this.group,
      required this.onPageChange,
      required this.onSelectForDeleting,
      required this.deletingIds,
      this.groupList});
  @override
  State<DetailGalleryPage> createState() => _DetailGalleryPageState();
}

class _DetailGalleryPageState extends State<DetailGalleryPage> {
  final stream = StreamController<int>();
  onMiniCardTap(GalleryFileEntity file, int index) {
    if (widget.deletingIds.isNotEmpty && widget.group.mainPhoto.id != file.id) {
      widget.onSelectForDeleting(file.id);
      setState(() {});
      return;
    }
    if (file.isVideo) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (BuildContext context) => VideoView(
            url: file.urlToFile,
            // url: index == 0
            // ? widget.group.mainPhoto.urlToFile
            // : index == 1
            // ? widget.group.mainVideo!.urlToFile
            // : widget.group.additionalFiles[index - 1 + (widget.group.mainVideo == null ? 0 : 1)].urlToFile,
            duration: null,
          ),
        ),
      );
    } else {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => PhotoFullScreenView(
                    urlToImage: file.urlToFile,
                    listGroup: widget.group,
                    index: index,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: stream.stream,
        builder: (context, snapshot) {
          return Scaffold(
            bottomNavigationBar:
                BottomNavigation(onTap: () => Navigator.pop(context)),
            backgroundColor: ColorStyles.backgroundColorGrey,
            body: Container(
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  print('DiR: ${details.delta.direction}');
                  if (details.delta.direction <= 0) {
                    Navigator.pop(context);
                  }
                },
                child: ArchiveWrapper(
                    currentIndex: 1,
                    scrollController: ScrollController(),
                    onChangePage: (index) {
                      Navigator.pop(context);
                      widget.onPageChange(index);
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Wrap(
                              spacing: 2.w,
                              runSpacing: 2.w,
                              children: List.generate(
                                  widget.group.additionalFiles.length +
                                      1 +
                                      (widget.group.mainVideo == null ? 0 : 1),
                                  (index) {
                                if (index == 0) {
                                  return GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Stack(
                                      children: [
                                        Hero(
                                            tag:
                                                '#${widget.group.mainPhoto.id}',
                                            child: _buildMiniItem(
                                                widget.group.mainPhoto)),
                                        Container(
                                          width: 140.w,
                                          height: 70.h,
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                Color(0xFF2C2C2E)
                                                    .withOpacity(0.5),
                                                Color(0xFF2C2C2E)
                                                    .withOpacity(0),
                                              ])),
                                        ),
                                        Positioned(
                                            top: 12.h,
                                            left: 12.h,
                                            child: Text(
                                              convertToRangeDates(widget.group),
                                              style: TextStyles(context)
                                                  .white_18_w800
                                                  .copyWith(
                                                      color: Colors.white
                                                          .withOpacity(0.7)),
                                            )),
                                        Positioned.fill(
                                          bottom: 140.h * 0.5,
                                          top: 0,
                                          child: GestureDetector(
                                            onLongPress: () {
                                              widget.onSelectForDeleting(
                                                  widget.group.mainPhoto.id);
                                              setState(() {});
                                            },
                                            onTap: () => Navigator.pop(context),
                                            behavior: HitTestBehavior.opaque,
                                          ),
                                        ),
                                        Positioned.fill(
                                          bottom: 0,
                                          top: 140.h * 0.5,
                                          child: GestureDetector(
                                            onLongPress: () {
                                              widget.onSelectForDeleting(
                                                  widget.group.mainPhoto.id);
                                              setState(() {});
                                            },
                                            onTap: () {
                                              onMiniCardTap(
                                                  widget.group.mainPhoto,
                                                  index);
                                            },
                                            behavior: HitTestBehavior.opaque,
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                                GalleryFileEntity currentFile =
                                    index == 1 && widget.group.mainVideo != null
                                        ? widget.group.mainVideo!
                                        : widget.group.additionalFiles[index -
                                            1 -
                                            (widget.group.mainVideo == null
                                                ? 0
                                                : 1)];
                                return MiniMediaCard(
                                    file: currentFile,
                                    onTap: () {
                                      onMiniCardTap(
                                          widget.group.mainPhoto, index);
                                    },
                                    onLongTap: () {
                                      widget
                                          .onSelectForDeleting(currentFile.id);
                                      setState(() {});
                                    },
                                    isSelected: widget.deletingIds
                                        .contains(currentFile.id));
                              })),
                          SizedBox(
                            height: 470.h,
                          )
                        ],
                      ),
                    )),
              ),
            ),
          );
        });
  }

  _buildMiniItem(GalleryFileEntity file) {
    return Container(
        height: 140.h,
        width: 140.w,
        color: ColorStyles.greyColor2,
        child: CachedNetworkImage(
          imageUrl:
              file.isVideo ? file.urlToPreviewVideoImage ?? '' : file.urlToFile,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ));
  }
}
