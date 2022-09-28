import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/custom_button.dart';

class InputNamePage extends StatefulWidget {
  const InputNamePage({Key? key}) : super(key: key);

  @override
  State<InputNamePage> createState() => _InputNamePageState();
}

class _InputNamePageState extends State<InputNamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              autofocus: true,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20)),
                            ),
                          ),
                          GestureDetector(
                            child: Image.asset(
                              'assets/nick_name_busy.png',
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
                    onPressed: () {},
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

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
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
        selection: TextSelection.collapsed(offset: string.length));
  }
}
