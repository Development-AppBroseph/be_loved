import 'dart:async';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAnimationButton extends StatefulWidget {
  final Border? border;
  final String text;
  bool black;
  bool red;
  final VoidCallback onPressed;
  bool? state;

  CustomAnimationButton(
      {Key? key,
      required this.text,
      this.black = false,
      this.red = false,
      required this.onPressed,
      this.border,
      this.state})
      : super(key: key);

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomAnimationButton>
    with SingleTickerProviderStateMixin {
  bool animation = true;

  late AnimationController controller;
  late Animation<Color?> _colorAnim;
  late Color color = const Color.fromRGBO(23, 23, 23, 1.0);
  Timer? _timer;
  final _streamController = StreamController<double>();
  double timePressed = 0;

  @override
  void initState() {
    super.initState();
    if(widget.red){
      color = ColorStyles.redColor;
    }
    controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _colorAnim = ColorTween(
            begin: widget.red ? ColorStyles.redColor : Color.fromRGBO(23, 23, 23, 1.0), end: Colors.white)
        .animate(controller);
    _colorAnim.addListener(() {
      setState(() {
        color = _colorAnim.value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
        stream: _streamController.stream,
        initialData: 0,
        builder: (context, snapshot) {
          return GestureDetector(
            child: AnimatedContainer(
              curve: Curves.easeInOutQuint,
              height: 60.sp,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: widget.red
                  ? ColorStyles.redColor
                  : snapshot.data! < 0.1
                      ? animation
                          ? const Color.fromRGBO(23, 23, 23, 1.0)
                          : widget.black
                              ? const Color.fromRGBO(23, 23, 23, 1.0)
                              : const Color.fromRGBO(32, 203, 131, 1.0)
                      : const Color.fromRGBO(32, 203, 131, 1.0),  
                  width: 1.sp,
                ),
              ),
              duration: const Duration(milliseconds: 300),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        onEnd: () {},
                        curve: Curves.easeInOutQuint,
                        height: 60.sp,
                        width: snapshot.data! > 0 ? 378.w : 0,
                        decoration: BoxDecoration(
                          color: widget.red
                          ? ColorStyles.redColor
                          : widget.black
                              ? const Color.fromRGBO(23, 23, 23, 1.0)
                              : const Color.fromRGBO(32, 203, 131, 1.0),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(widget.text,
                          style: GoogleFonts.inter(
                            fontSize: 20.sp,
                            color: color,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ],
                ),
              ),
            ),
            onForcePressStart: (details) {
              // print(details);
              // print('end');
            },
            onTapDown: (details) {
              print(details.globalPosition.distance);
              print('start');
              controller.forward();
              _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
                timePressed += 0.1;
                _streamController.sink.add(timePressed);
              });
            },
            // onLongPressStart: (details) {
            //   print(details.globalPosition.distance);
            //   print('start');
            //   controller.forward();
            //   _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
            //     timePressed += 0.1;
            //     _streamController.sink.add(timePressed);
            //   });
            // },
            onTapUp: (details) {
              print('end');

              _timer?.cancel();
              if (snapshot.data! > 0.6) {
                widget.onPressed();
                _streamController.sink.add(0.6);
              } else {
                controller.animateBack(0);
                _streamController.sink.add(0);
                timePressed = 0;
              }
            },
            // onLongPress: () {
            //   // if(widget.state != null && widget.state!) {
            //   setState(() {
            //     controller.forward();
            //     animation = false;
            //   });
            //   // }
            // },
          );
        });
  }
}
