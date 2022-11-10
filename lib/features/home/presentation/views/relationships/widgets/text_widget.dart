import 'package:be_loved/core/utils/helpers/text_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TextWidget extends StatelessWidget {
  final String text;
  const TextWidget({required this.text});

  TextStyle getStyle(){
    return TextStyle(
      fontWeight: FontWeight.w800, 
      color: Colors.white, 
      fontSize: textSizeByLength(text).sp
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: getStyle(),
      overflow: TextOverflow.ellipsis,
    );
  }
}