import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/widgets/buttons/back_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';



class PhotoFullScreenView extends StatelessWidget {
  String urlToImage;
  PhotoFullScreenView({required this.urlToImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.blackColor,
      body: Stack(
        children: [
          PhotoView(
            imageProvider: NetworkImage(urlToImage)
          ),
          Positioned(
            top: 30.h+MediaQuery.of(context).padding.top,
            right: 30.w,
            child: BackBtn(
              onTap: (){
                Navigator.pop(context);
              } 
            )
          ),
        ],
      ),
    );
  }
}