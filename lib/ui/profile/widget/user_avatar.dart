import 'package:be_loved/core/helpers/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String title;
  const UserAvatar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 135,
          width: 135,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Img.avatarNone),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
      ],
    );
  }
}
