import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/profile/presentation/widget/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AvatarAndNameUser extends StatelessWidget {
  const AvatarAndNameUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        UserAvatar(
          title: "Ник",
          fontSize: 25.sp,
        ),
        SvgPicture.asset(
          SvgImg.logov2,
          color: const Color(0xff171717),
        ),
        UserAvatar(
          title: "12 символов",
          fontSize: 18.sp,
        ),
      ],
    );
  }
}
