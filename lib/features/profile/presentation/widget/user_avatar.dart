import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/utils/helpers/text_size.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAvatar extends StatelessWidget {
  final String title;
  final double fontSize;
  final String? image;
  UserAvatar({
    Key? key,
    required this.title,
    required this.fontSize,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 135.w,
      child: Column(
        children: [
          Container(
            height: 135.h,
            width: 135.h,
            decoration: image == null
                ? const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(Img.avatarNone),
                    ),
                  )
                : BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(40.r),
                    ),
                    border: Border.all(width: 5.h, color: Colors.white),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: getImage(image),
                    ),
                  ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Text(
              title,
              style: getStyle(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle getStyle() {
    return TextStyle(
      fontFamily: 'Inter',
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: textSizeByLength(title).sp,
    );
  }

  ImageProvider<Object> getImage(String? path) {
    if (path != null && path.trim() != '') {
      return NetworkImage(Config.url.url + path);
    }
    return AssetImage('assets/images/avatar_none.png');
  }
}
