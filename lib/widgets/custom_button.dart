import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatefulWidget {

  final Color color;
  final Color textColor;
  final Border? border;
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.color,
    required this.text,
    required this.textColor,
    required this.onPressed,
    this.border,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 60.sp,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
          border: widget.border,
        ),
        child: Text(
            widget.text,
            style: GoogleFonts.inter(
              fontSize: 20.sp,
              color: widget.textColor,
              fontWeight: FontWeight.bold,
            )
        ),
      ),
      onTap: () {
        widget.onPressed();
      },
    );
  }
}
