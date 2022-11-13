import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/profile/presentation/widget/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../locator.dart';

class AvatarAndNameUser extends StatelessWidget {
  const AvatarAndNameUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        UserAvatar(
          title: sl<AuthConfig>().user == null
              ? ''
              : sl<AuthConfig>().user!.me.username,
          fontSize: 25.sp,
          image: sl<AuthConfig>().user == null
              ? null
              : sl<AuthConfig>().user!.me.photo,
        ),
        SvgPicture.asset(
          SvgImg.logov2,
          color: const Color(0xff171717),
        ),
        UserAvatar(
          title: sl<AuthConfig>().user == null ||
                  sl<AuthConfig>().user?.love == null
              ? ''
              : sl<AuthConfig>().user!.love!.username,
          fontSize: 18.sp,
          image: sl<AuthConfig>().user == null ||
                  sl<AuthConfig>().user!.love == null
              ? null
              : sl<AuthConfig>().user!.love!.photo,
        ),
      ],
    );
  }
}
