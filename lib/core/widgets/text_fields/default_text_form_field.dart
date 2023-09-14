import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultTextFormField extends StatelessWidget {
  final String hint;
  final String? title;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? isValidate;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final Function()? onTap;
  final Function(String? val)? onChange;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? maxLength;
  final bool hideCounter;
  bool isEmail;
  DefaultTextFormField({
    Key? key,
    this.focusNode,
    this.maxLength,
    this.hideCounter = false,
    this.isEmail = false,
    this.onTap,
    this.onChange,
    this.maxLines,
    required this.hint,
    this.title,
    this.validator,
    this.isValidate = true,
    this.controller,
    this.inputFormatters,
    this.keyboardType,
  }) : super(key: key);
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
          style: TextStyles(context).black_18_w800.copyWith(
              color: sl<AuthConfig>().idx == 1 && isEmail == true
                  ? ColorStyles.greyColor
                  : ClrStyle.black17ToWhite[sl<AuthConfig>().idx]),
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
            fillColor: isValidate!
                ? ClrStyle
                    .backToBlack2C[isEmail == true ? 0 : sl<AuthConfig>().idx]
                : sl<AuthConfig>().idx == 1
                    ? ClrStyle.backToBlack2C[1]
                    : ColorStyles.validateColor,
            hintStyle: TextStyles(context).grey_18_w800.copyWith(
                  color: sl<AuthConfig>().idx == 1 && isEmail == true
                      ? ColorStyles.greyColor
                      : null,
                ),
          ),
        ),
        if (!hideCounter && maxLength != null && controller?.text.length == 0)
          Positioned(
              right: 20.w,
              top: 16.h,
              child: Text(
                '${controller?.text.length}/$maxLength',
                style: TextStyles(context).grey_15_w800,
              ))
      ],
    );
  }
}
