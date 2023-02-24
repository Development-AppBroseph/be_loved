import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/utils/helpers/text_size.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAvatar extends StatefulWidget {
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
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 135.w,
          child: Column(
            children: [
              Stack(
                children: [
                  if (widget.image != null && widget.image?.trim() != '')
                    Material(
                      type: MaterialType.transparency,
                      borderRadius: BorderRadius.all(
                        Radius.circular(40.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.r),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: Config.url.url + widget.image!,
                          height: 135.h,
                          fadeInCurve: Curves.easeInOutQuint,
                          fadeOutCurve: Curves.easeInOutQuint,
                          fit: BoxFit.cover,
                          width: 135.w,
                        ),
                      ),
                    ),
                  Container(
                    height: 135.h,
                    width: 135.h,
                    decoration: widget.image == null
                        ? const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(Img.avatarNone),
                            ),
                          )
                        : BoxDecoration(
                            // color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(40.r),
                            ),
                            // border: Border.all(width: 5.h, color: Colors.white),
                            image: widget.image == null ||
                                    widget.image?.trim() == ''
                                ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: getImage(widget.image),
                                  )
                                : null,
                          ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h),
                child: Text(
                  widget.title,
                  style: getStyle(),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle getStyle() {
    return TextStyle(
      fontFamily: 'Inter',
      color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
      fontWeight: FontWeight.bold,
      fontSize: textSizeByLength(widget.title).sp,
    );
  }

  ImageProvider<Object> getImage(String? path) {
    if (path != null && path.trim() != '') {
      return NetworkImage(Config.url.url + path);
    }
    return AssetImage('assets/images/avatar_none.png');
  }
}
