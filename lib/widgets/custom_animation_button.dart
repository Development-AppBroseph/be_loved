import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAnimationButton extends StatefulWidget {
  final Border? border;
  final String text;
  final VoidCallback onPressed;

  const CustomAnimationButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.border,
  }) : super(key: key);

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomAnimationButton> with SingleTickerProviderStateMixin{
  bool animation = true;

  late AnimationController controller;
  late Animation<Color?> _colorAnim;
  late Color color = Color.fromRGBO(23, 23, 23, 1.0);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _colorAnim = ColorTween(begin: Color.fromRGBO(23, 23, 23, 1.0), end: Colors.white).animate(controller);
    _colorAnim.addListener((){
      setState(() {
        color = _colorAnim.value!;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        height: 60.sp,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: animation ? Color.fromRGBO(23, 23, 23, 1.0) : Color.fromRGBO(32, 230, 131, 1.0), width: 2.sp),
        ),
        duration: Duration(milliseconds: 300),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 1000),
                onEnd: widget.onPressed,
                curve: Curves.fastOutSlowIn,
                height: 60.sp,
                width: animation ? 0 : 378.w,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(32, 230, 131, 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                  widget.text,
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    color: color,
                    fontWeight: FontWeight.bold,
                  )
              ),
            )
          ],
        ),
      ),
      onTap: () {
        setState(() {
          controller.forward();
          animation = false;
        });
      },
    );
  }
}
