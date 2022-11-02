import 'package:be_loved/core/helpers/images.dart';
import 'package:be_loved/ui/profile/widget/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AvatarAndNameUser extends StatelessWidget {
  const AvatarAndNameUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const UserAvatar(title: "Ник"),
          SvgPicture.asset(
            SvgImg.logov2,
            color: const Color(0xff171717),
          ),
          const UserAvatar(title: "12 символов"),
        ],
      ),
    );
  }
}
