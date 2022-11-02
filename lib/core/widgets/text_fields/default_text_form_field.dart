import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../helpers/constants.dart';



class DefaultTextFormField extends StatelessWidget {
  final String hint;
  final String? title;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final Function(String? val)? onChange;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? maxLength;
  DefaultTextFormField({
    Key? key,
    this.focusNode,
    this.maxLength,
    this.onTap,
    this.onChange,
    this.maxLines,
    required this.hint,
    this.title,
    this.validator,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
  }) : super(key: key);
  TextStyle style = TextStyle(
    color: Color(0xFF2C2C2E),
    fontSize: 18.sp,
    fontWeight: FontWeight.w800
  );
  TextStyle style2 = TextStyle(
    color: greyColor,
    fontSize: 18.sp,
    fontWeight: FontWeight.w800
  );
  TextStyle style3 = TextStyle(
    color: greyColor,
    fontSize: 15.sp,
    fontWeight: FontWeight.w800
  );
  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: [
        TextFormField(
          focusNode: focusNode,
          onTap: onTap,
          onChanged: onChange,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          controller: controller,
          maxLines: maxLines,
          style: style,
          maxLength: maxLength,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(20.h),
            hintText: hint,
            filled: true,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.r),
              borderSide: BorderSide.none,
            ),
            fillColor: backgroundColorGrey,
            hintStyle: style2
          ),
        ),
        if(maxLength != null && controller?.text.length == 0)
        Positioned(
          right: 20.w,
          top: 16.h,
          child: Text('${controller?.text.length}/$maxLength', style: style3,)
        )
      ],
    );
  }
}