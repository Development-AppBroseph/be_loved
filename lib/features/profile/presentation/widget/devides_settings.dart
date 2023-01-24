import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/widgets/buttons/switch_btn.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DevideSettings extends StatefulWidget {
  final String title;
  final String subtitle;
  final String icon;
  final bool haveToggleSwitch;
  Function()? onPressed;
  DevideSettings({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.haveToggleSwitch,
    this.onPressed,
  }) : super(key: key);

  @override
  State<DevideSettings> createState() => _DevideSettingsState();
}

class _DevideSettingsState extends State<DevideSettings> {
  bool switchValue = true;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onPressed != null ? widget.onPressed!() : null,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 12.h),
        child: Row(
          children: [
            SizedBox(
              height: 34.h,
              width: 34.w,
              child: SvgPicture.asset(
                widget.icon,
                color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
              ),
            ),
            SizedBox(
              width: 27.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff969696),
                  ),
                ),
              ],
            ),
            const Spacer(),
            widget.haveToggleSwitch
                ? SwitchBtn(
                    onChange: (value) {
                      setState(() {
                        switchValue = value;
                      });
                    },
                    value: switchValue,
                  )
                : IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_forward_ios_rounded),
                    color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                  ),
          ],
        ),
      ),
    );
  }
}
