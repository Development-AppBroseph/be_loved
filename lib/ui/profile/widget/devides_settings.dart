import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../widgets/buttons/switch_btn.dart';

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
  bool switchValue = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            height: 34,
            width: 34,
            child: SvgPicture.asset(
              widget.icon,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            width: 27,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff171717),
                ),
              ),
              Text(
                widget.subtitle,
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff969696),
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
