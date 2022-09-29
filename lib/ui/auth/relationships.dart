import 'package:be_loved/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RelationShips extends StatelessWidget {
  const RelationShips({Key? key}) : super(key: key);

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
                          text: 'Когда начались\n',
                          style: GoogleFonts.inter(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromRGBO(23, 23, 23, 1.0),
                          ),
                        ),
                        TextSpan(
                          text: 'ваши ',
                          style: GoogleFonts.inter(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromRGBO(255, 29, 29, 1.0),
                          ),
                        ),
                        TextSpan(
                          text: 'отношения?',
                          style: GoogleFonts.inter(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromRGBO(23, 23, 23, 1.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20.sp, bottom: 10.sp),
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
                          Text('Никита Белых', 
                            style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromRGBO(23, 23, 23, 1.0),
                          ),)
                        ],
                      ),
                      SvgPicture.asset('assets/icons/logov2.svg'),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20.sp, bottom: 10.sp),
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
                          Text('Аня Пешкова', 
                            style: GoogleFonts.inter(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromRGBO(23, 23, 23, 1.0),
                          ),)
                        ],
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 60.sp,
                    width: 0.78.sw,
                    child: TextField(
                      style: GoogleFonts.inter(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                        color:const Color.fromRGBO(150, 150, 150, 1.0)),
                        autofocus: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20)),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  CustomButton(
                    color: const Color.fromRGBO(32, 203, 131, 1.0),
                    text: 'Продолжить',
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
