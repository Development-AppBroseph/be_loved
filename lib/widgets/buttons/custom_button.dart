import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {
  final Color color;
  bool visible;
  final Color textColor;
  final Border? border;
  final String text;
  final VoidCallback onPressed;

  CustomButton({
    Key? key,
    required this.color,
    this.visible = true,
    required this.text,
    required this.textColor,
    required this.onPressed,
    this.border,
  }) : super(key: key);

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: widget.visible ? 1 : 0,
      child: GestureDetector(
        child: Container(
          height: 60.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(10),
            border: widget.border,
          ),
          child: Text(widget.text,
              style: GoogleFonts.inter(
                fontSize: 20.sp,
                color: widget.textColor,
                fontWeight: FontWeight.bold,
              )),
        ),
        onTap: () {
          widget.onPressed();
        },
      ),
    );
  }
}
