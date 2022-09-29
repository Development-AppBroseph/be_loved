import 'package:be_loved/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class InvitePartner extends StatelessWidget {
  const InvitePartner({Key? key, required this.nextPage, required this.previousPage}) : super(key: key);

  final VoidCallback nextPage;
  final VoidCallback previousPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
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
                          text: 'Пригласи ',
                          style: GoogleFonts.inter(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromRGBO(23, 23, 23, 1.0),
                          ),
                        ),
                        TextSpan(
                          text: 'партнёра',
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
                    'Позови партнёра на этот экран, введи его\nникнейм, и ожидай принятия приглашения',
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      color: const Color.fromRGBO(137, 137, 137, 1.0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
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
                      SvgPicture.asset('assets/icons/logo.svg'),
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
                    onPressed: nextPage,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  AppBar appBar(BuildContext context) {
    int indexPage = 3;
    return AppBar(
      elevation: 0,
      toolbarHeight: 80.sp,
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
      title: Padding(
        padding: EdgeInsets.only(left: 20.sp, top: 40.sp, right: 6.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: previousPage,
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                width: 15.sp,
              ),
            ),
            SizedBox(
                  height: 5.sp,
                  width: 55,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (BuildContext context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 3.sp),
                        height: 5.sp,
                        width: 5.sp,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1.5),
                          color: indexPage == index
                              ? Colors.blue
                              : indexPage > index
                                  ? Colors.black
                                  : Colors.white,
                          border: indexPage + 1 > index
                              ? null
                              : Border.all(
                                  width: 1,
                                  color: const Color.fromRGBO(255, 29, 29, 1.0),
                                ),
                        ),
                      );
                    },
                  ),
                )
          ],
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }
}
