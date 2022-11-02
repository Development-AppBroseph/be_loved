import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DevideSettings extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            color: Colors.black,
            height: 32,
            width: 32,
          ),
          const SizedBox(
            width: 27,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff171717),
                ),
              ),
              Text(
                subtitle,
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
          IconButton(
            onPressed: () {
              print('lol');
            },
            icon: const Icon(Icons.arrow_forward_ios_rounded),
          ),
        ],
      ),
    );
  }
}
