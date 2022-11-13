import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  final Color color;
  bool visible;
  bool? validate;
  final Color textColor;
  bool code;
  final Border? border;
  final String text;
  final VoidCallback onPressed;
  final String? svg;
  final double? svgHeight;

  CustomButton({
    Key? key,
    this.svg,
    this.svgHeight,
    required this.color,
    this.visible = true,
    this.code = false,
    this.validate = false,
    required this.text,
    required this.textColor,
    required this.onPressed,
    this.border,
  }) : super(key: key);

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  late bool wasClicked;

  @override
  void didChangeDependencies() {
    wasClicked = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    wasClicked = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      return AnimatedOpacity(
        curve: Curves.easeInOutQuint,
        duration: const Duration(milliseconds: 200),
        opacity: widget.visible ? 1 : 0,
        child: Material(
          color: widget.validate == null
              ? state is TextFieldSuccess
                  ? widget.color
                  : Colors.transparent
              : widget.code
                  ? widget.validate!
                      ? widget.color
                      : Colors.transparent
                  : state is TextFieldSuccess || (widget.validate!)
                      ? widget.color
                      : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            highlightColor: widget.validate == null
                ? state is TextFieldSuccess
                    ? const Color.fromRGBO(112, 200, 163, 1)
                    : Colors.transparent
                : widget.code
                    ? widget.validate! || state is TextFieldSuccess
                        ? widget.color != Colors.black
                            ? const Color.fromRGBO(112, 200, 163, 1)
                            : Colors.transparent
                        : Colors.transparent
                    : state is TextFieldSuccess || (widget.validate!)
                        ? widget.color != Colors.black
                            ? const Color.fromRGBO(112, 200, 163, 1)
                            : Colors.transparent
                        : Colors.transparent,
            child: AnimatedContainer(
              curve: Curves.easeInOutQuint,
              duration: const Duration(milliseconds: 200),
              height: 60.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: widget.validate == null
                    ? state is TextFieldSuccess
                        ? widget.border
                        : Border.all(
                            width: 1,
                            color: const Color.fromRGBO(23, 23, 23, 1),
                          )
                    : widget.code
                        ? widget.validate!
                            ? widget.border
                            : Border.all(
                                width: 1,
                                color: const Color.fromRGBO(23, 23, 23, 1),
                              )
                        : state is TextFieldSuccess || (widget.validate!)
                            ? widget.border
                            : Border.all(
                                width: 1,
                                color: const Color.fromRGBO(23, 23, 23, 1),
                              ),
              ),
              child: widget.svg != null
                  ? SvgPicture.asset(
                      widget.svg ?? SvgImg.persons,
                      height: widget.svgHeight,
                      color: widget.validate == null
                          ? state is TextFieldSuccess
                              ? widget.textColor
                              : const Color.fromRGBO(23, 23, 23, 1)
                          : widget.code
                              ? widget.validate!
                                  ? widget.textColor
                                  : const Color.fromRGBO(23, 23, 23, 1)
                              : state is TextFieldSuccess || (widget.validate!)
                                  ? widget.textColor
                                  : const Color.fromRGBO(23, 23, 23, 1),
                    )
                  : Text(
                      widget.text,
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        color: widget.validate == null
                            ? state is TextFieldSuccess
                                ? widget.textColor
                                : const Color.fromRGBO(23, 23, 23, 1)
                            : widget.code
                                ? widget.validate!
                                    ? widget.textColor
                                    : const Color.fromRGBO(23, 23, 23, 1)
                                : state is TextFieldSuccess ||
                                        (widget.validate!)
                                    ? widget.textColor
                                    : const Color.fromRGBO(23, 23, 23, 1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            onTap: () {
              if (!wasClicked) {
                if (widget.validate != null) {
                  if ((state is TextFieldSuccess ||
                          widget.validate! ||
                          widget.svg != null) ||
                      widget.color == ColorStyles.redColor) {
                    widget.onPressed();
                  }
                } else {}
              } else if (!wasClicked) {
                setState(() {
                  wasClicked = !wasClicked;
                });
              }
            },
          ),
        ),
      );
    });
  }
}
