import 'package:be_loved/core/helpers/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAvatar extends StatelessWidget {
  final String title;
  const UserAvatar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 135.h,
          width: 135.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Img.avatarNone),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.w),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25.sp,
            ),
          ),
        ),
      ],
    );
  }
}
