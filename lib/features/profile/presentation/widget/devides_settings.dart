import 'package:be_loved/core/widgets/buttons/switch_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DevideSettings extends StatefulWidget {
  final String title;
  final String subtitle;
  final String icon;
  final bool haveToggleSwitch;
  const DevideSettings(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.icon,
      required this.haveToggleSwitch})
      : super(key: key);

  @override
  State<DevideSettings> createState() => _DevideSettingsState();
}

class _DevideSettingsState extends State<DevideSettings> {
  bool switchValue = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 12.h),
      child: Row(
        children: [
          SizedBox(
            height: 34.h,
            width: 34.w,
            child: SvgPicture.asset(
              widget.icon,
              color: Colors.black,
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
                  color: const Color(0xff171717),
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
                ),
        ],
      ),
    );
  }
}
