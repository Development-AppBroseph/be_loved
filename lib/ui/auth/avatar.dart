import 'dart:async';
import 'package:be_loved/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AvatarPage extends StatelessWidget {
  const AvatarPage({Key? key, required this.onTap}) : super(key: key);

  final VoidCallback onTap;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
      body: SafeArea(
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.sp),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 0.sh),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Поставь ',
                          style: GoogleFonts.inter(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromRGBO(23, 23, 23, 1.0),
                          ),
                        ),
                        TextSpan(
                          text: 'аватарку',
                          style: GoogleFonts.inter(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromRGBO(255, 29, 29, 1.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Выбери из предложенных вариантов, или\nпоставь свою ',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      color: const Color.fromRGBO(137, 137, 137, 1.0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.sp, bottom: 36.sp),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(43.h),
                        height: 135.h,
                        width: 135.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35.sp),
                          color: const Color.fromRGBO(150, 150, 150, 1.0),
                        ),
                        child: SvgPicture.asset('assets/icons/camera.svg'),
                      ),
                    ),
                  ),
                  Container(
                    height: 267.h,
                    width: 378.w,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(228, 228, 228, 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AvatarMenu(),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  CustomButton(
                    color: const Color.fromRGBO(32, 203, 131, 1.0),
                    text: 'Продолжить',
                    textColor: Colors.white,
                    onPressed: () => onTap(),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

class AvatarMenu extends StatelessWidget {
  AvatarMenu({Key? key}) : super(key: key);

  final streamController = StreamController<int>();
  final pageController = PageController(viewportFraction: 1.0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              PageTest(),
              PageTest(),
              PageTest(),
              PageTest(),
            ],
          )
        ),
        Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(216, 216, 216, 1.0),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.sp),
            child: StreamBuilder<int>(
              initialData: 0,
              stream: streamController.stream,
              builder: (context, page) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        pageController.jumpToPage(0);
                        streamController.add(0);
                      },
                      child: SvgPicture.asset('assets/icons/men.svg', color: page.data == 0 ? Colors.black : Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        pageController.jumpToPage(1);
                        streamController.add(1);
                      },
                      child: SvgPicture.asset('assets/icons/women.svg', color: page.data == 1 ? Colors.black : Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        pageController.jumpToPage(2);
                        streamController.add(2);
                      },
                      child: SvgPicture.asset('assets/icons/paw.svg', color: page.data == 2 ? Colors.black : Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        pageController.jumpToPage(3);
                        streamController.add(3);
                      },
                      child: SvgPicture.asset('assets/icons/rects.svg', color: page.data == 3 ? Colors.black : Colors.grey)),
                  ],
                );
              }
            ),
          ),
        )
      ],
    );
  }
}

class PageTest extends StatelessWidget {
  const PageTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: ((context, index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(150, 150, 150, 1),
              borderRadius: BorderRadius.circular(18.sp)),
          ),
        );
      })
    );
  }
}
