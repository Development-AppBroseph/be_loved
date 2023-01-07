import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/features/home/domain/entities/archive/gallery_file_entity.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/gallery/main_media_card.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/gallery/selected_check.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class MiniMediaCard extends StatelessWidget {
  final GalleryFileEntity file;
  final Function() onTap;
  final bool isSelected;
  const MiniMediaCard({required this.file, required this.onTap, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 140.h,
            width: 140.w,
            color: ColorStyles.greyColor2,
            child: CachedNetworkImage(
              imageUrl: file.isVideo ? file.urlToPreviewVideoImage ?? '' : file.urlToFile,
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            )
          ),
          if(isSelected)
          Container(
            width: 140.w,
            height: 140.w,
            color: Colors.white.withOpacity(0.3),
          ),
          if(isSelected)
          SelectedCheck(isMiniCard: true,),

          if(file.isVideo && file.duration != null)
          Positioned(
            top: 12.h,
            right: 12.w,
            child: Text(formatDuration(Duration(seconds: file.duration!)), style: TextStyles(context).white_15_w800)
          )
        ],
      ),
    );
  }
}