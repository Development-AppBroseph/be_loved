import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/widgets/buttons/back_btn.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_group_files_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoFullScreenView extends StatefulWidget {
  final String urlToImage;
  final GalleryGroupFilesEntity? listGroup;
  final List<GalleryFileEntity>? file;
  final int? index;
  const PhotoFullScreenView({
    Key? key,
    required this.urlToImage,
    this.listGroup,
    this.file,
    this.index,
  }) : super(key: key);

  @override
  State<PhotoFullScreenView> createState() => _PhotoFullScreenViewState();
}

class _PhotoFullScreenViewState extends State<PhotoFullScreenView> {
  List<dynamic> files = [];
  void getListFiles() {
    if (widget.listGroup == null) {
      for (var i = 0; i < widget.file!.length; i++) {
        files.add(widget.file![i].urlToFile);
      }
    } else {
      files.add(widget.listGroup!.mainPhoto.urlToFile);
      for (var i = 0; i < widget.listGroup!.additionalFiles.length; i++) {
        files.add(widget.listGroup!.additionalFiles[i].urlToFile);
      }
    }
  }

  @override
  void initState() {
    getListFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.blackColor,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: PageController(initialPage: widget.index!),
            itemCount: files.length,
            builder: (context, index) => PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(files[index]),
            ),
          ),
          Positioned(
              top: 30.h + MediaQuery.of(context).padding.top,
              right: 30.w,
              child: BackBtn(onTap: () {
                Navigator.pop(context);
              })),
        ],
      ),
    );
  }
}
