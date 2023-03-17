import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/widgets/buttons/back_btn.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_group_files_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoFullScreenView extends StatelessWidget {
  final String urlToImage;
  final GalleryGroupFilesEntity? listGroup;
  final GalleryFileEntity? file;
  const PhotoFullScreenView(
      {Key? key, required this.urlToImage, this.listGroup, this.file})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> files = [];
    files.add(urlToImage);
    for (var i = 0; i < listGroup!.additionalFiles.length; i++) {
      files.add(listGroup!.additionalFiles[i].urlToFile);
    }
    // for (var element in listGroup!.additionalFiles) {
    //   files.add(urlToImage);
    //   files.add(element);
    // }
    return Scaffold(
      backgroundColor: ColorStyles.blackColor,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: files.length,
            builder: (context, index) => PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(files[index]),
            ),
          ),
          // PhotoView.builder(
          //   imageProvider: NetworkImage(urlToImage)
          // ),
          Positioned(
            top: 30.h + MediaQuery.of(context).padding.top,
            right: 30.w,
            child: BackBtn(
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
