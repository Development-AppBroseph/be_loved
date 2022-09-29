import 'package:be_loved/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class InputNamePage extends StatelessWidget {
  const InputNamePage({Key? key, required this.nextPage}) : super(key: key);

  final VoidCallback nextPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
      body: SafeArea(
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.sp),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 0.15.sh),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Как тебя ',
                            style: GoogleFonts.inter(
                              fontSize: 35.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(23, 23, 23, 1.0),
                            )),
                        TextSpan(
                            text: 'зовут?',
                            style: GoogleFonts.inter(
                                fontSize: 35.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromRGBO(255, 29, 29, 1.0))),
                      ],
                    ),
                  ),
                  Text(
                    'Максимальная длина никнейма — 12\nсимволов ',
                    style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        color: const Color.fromRGBO(137, 137, 137, 1.0),
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 44.sp),
                    child: Container(
                      height: 70.sp,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 60.sp,
                            width: 0.78.sw,
                            child: TextField(
                              style: GoogleFonts.inter(
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color.fromRGBO(150, 150, 150, 1.0)),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20)),
                            ),
                          ),
                          GestureDetector(
                            child: Image.asset(
                              'assets/images/nick_name_busy.png',
                              height: 21.sp,
                            ),
                            onTap: () {},
                          )
                        ],
                      ),
                    ),
                  ),
                  CustomButton(
                    color: const Color.fromRGBO(32, 203, 131, 1.0),
                    text: 'Продолжить',
                    textColor: Colors.white,
                    onPressed: nextPage,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  AppBar appBar(BuildContext context) {
    int indexPage = 1;
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
              onTap: () => Navigator.pop(context),
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
