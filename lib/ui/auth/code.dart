import 'package:be_loved/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'create_account_info.dart';

class CodePage extends StatelessWidget {
  CodePage({Key? key}) : super(key: key);
  
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80.sp,
        backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
        title: Padding(
          padding: EdgeInsets.only(left: 20.sp, top: 40.sp, right: 6.sp),
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                width: 15.sp,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.sp),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 0.15.sh),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Введи код подтверждения',
                    style: GoogleFonts.inter(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'В ближайшее время вам придёт sms-\nсообщение с кодом подтверждения',
                    style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        color: const Color.fromRGBO(137, 137, 137, 1.0),
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 44.sp),
                    child: SizedBox(
                      height: 70.sp,
                      child: Pinput(
                        showCursor: false,
                        length: 5,
                        focusNode: focusNode,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        onChanged: (value) {
                          if (value.length == 5) {
                            focusNode.unfocus();
                          }
                        },
                        defaultPinTheme: PinTheme(
                          width: 60.sp,
                          height: 80.sp,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          textStyle: GoogleFonts.inter(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromRGBO(23, 23, 23, 1.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  CustomButton(
                    color: const Color.fromRGBO(32, 203, 131, 1.0),
                    text: 'Продолжить',
                    textColor: Colors.white,
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountInfo())),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    color: const Color.fromRGBO(0, 0, 0, 0.0),
                    text: 'Отправить код снова',
                    textColor: const Color.fromRGBO(23, 23, 23, 1.0),
                    border: Border.all(
                        color: const Color.fromRGBO(23, 23, 23, 1.0),
                        width: 2.sp),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
