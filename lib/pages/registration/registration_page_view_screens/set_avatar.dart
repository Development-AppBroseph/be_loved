import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/custom_button.dart';

class SetAvatar extends StatefulWidget {
  const SetAvatar({Key? key}) : super(key: key);

  @override
  State<SetAvatar> createState() => _SetAvatarState();
}

class _SetAvatarState extends State<SetAvatar> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.sp),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 0.sh),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:   [
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Поставь ',
                            style: GoogleFonts.inter(
                              fontSize: 35.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(23, 23, 23, 1.0),
                            )
                        ),
                        TextSpan(
                            text: 'аватарку',
                            style: GoogleFonts.inter(
                                fontSize: 35.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromRGBO(255, 29, 29, 1.0)
                            )
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Выбери из предложенных вариантов, или\nпоставь свою ',
                    style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        color: const Color.fromRGBO(137, 137, 137, 1.0),
                        fontWeight: FontWeight.w600
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
                          color: const Color.fromRGBO(150, 150, 150, 1.0)
                        ),
                        child: Image.asset('assets/default_avatar.png'),
                      ),
                    ),
                  ),
                  Container(
                    height: 312.h,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(216, 216, 216, 1.0),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Container(),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  CustomButton(
                    color: const Color.fromRGBO(32, 203, 131, 1.0),
                    text: 'Продолжить',
                    textColor: Colors.white,
                    onPressed: () {
                    },
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    print(newValue.text);
    print(oldValue.text);

    if (newValue.text.length > 1) {
      text = oldValue.text;
    } else {
      text = newValue.text;
    }
    var buffer = StringBuffer();
    buffer.write(text);

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length)
    );
  }
}
