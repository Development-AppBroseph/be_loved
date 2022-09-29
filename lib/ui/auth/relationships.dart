import 'package:be_loved/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class RelationShips extends StatelessWidget {
  const RelationShips({Key? key, required this.previewPage, required this.prevPage}) : super(key: key);

  final VoidCallback previewPage;
  final VoidCallback prevPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
      body: SafeArea(
          bottom: true,
          child: Padding(
            padding: EdgeInsets.only(left: 24.sp, right: 24.sp, top: 0.1.sw),
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
                            color: const Color.fromRGBO(23, 23, 23, 1.0),
                          ),
                        ),
                        TextSpan(
                          text: 'отношения?',
                          style: GoogleFonts.inter(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromRGBO(255, 29, 29, 1.0),
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
                  SizedBox(
                    height: 206.h,
                    child: ScrollDatePicker(
                      locale: const Locale('en'),
                      onDateTimeChanged: (DateTime value) {
                        print(value);
                      }, selectedDate: DateTime(0),
                    ),
                  ),
                  CustomButton(
                    color: const Color.fromRGBO(32, 203, 131, 1.0),
                    text: 'Готово',
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          )),
    );
  }

  AppBar appBar(BuildContext context) {
    int indexPage = 4;
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
              onTap: prevPage,
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
