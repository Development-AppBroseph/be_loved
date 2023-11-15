import 'dart:typed_data';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/presentation/views/archive/helpers/video_helper.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VideoFileImage extends StatefulWidget {
  GalleryFileEntity file;
  VideoFileImage({required this.file});

  @override
  State<VideoFileImage> createState() => _VideoFileImageState();
}

class _VideoFileImageState extends State<VideoFileImage> {
  Uint8List? file;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initFile();
  }

  initFile() async {
    file = await getVideoFrame(widget.file.urlToFile);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return file == null
        ? Container(
            color: ColorStyles.backgroundColorGrey,
          )
        : Image(
            image: MemoryImage(file!),
            fit: BoxFit.cover,
          );
  }
}
