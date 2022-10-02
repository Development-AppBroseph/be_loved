import 'package:be_loved/core/app_data.dart';
import 'package:be_loved/ui/auth/code.dart';
import 'package:be_loved/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({Key? key}) : super(key: key);

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  FocusNode focusNode = FocusNode();
  String phoneNumber = '';
  AppData appData = AppData('');

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80.sp,
        backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
      ),
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
                  Text(
                    'Войти по номеру телефона',
                    style: GoogleFonts.inter(
                      fontSize: 35.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Войти в уже существующий аккаунт,\nили создать новый',
                    style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        color: const Color.fromRGBO(137, 137, 137, 1.0),
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 44.sp),
                    child: Container(
                      height: 70.sp,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(0),
                              right: Radius.circular(10))),
                      child: Row(
                        children: [
                          Image.asset('assets/images/code_region.png'),
                          SizedBox(
                            width: 12.w,
                          ),
                          Text(
                            '+7',
                            style: GoogleFonts.inter(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Container(
                            height: 37.h,
                            width: 1.w,
                            color: const Color.fromRGBO(224, 224, 224, 1.0),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Container(
                            width: 0.6.sw,
                            alignment: Alignment.center,
                            child: TextField(
                              style: GoogleFonts.inter(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                phoneNumber = '+7${value.replaceAll(RegExp(' '), '')}';
                                if (value.length > 12) {
                                  focusNode.unfocus();
                                }
                              },
                              focusNode: focusNode,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                CustomInputFormatter(),
                              ],
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomButton(
                    color: const Color.fromRGBO(32, 203, 131, 1.0),
                    text: 'Продолжить',
                    textColor: Colors.white,
                    onPressed: () {
                      if (phoneNumber.length == 12) {
                        Provider.of<AppData>(context, listen: false).getRegCode(phoneNumber);
                        Provider.of<AppData>(context, listen: false).saveNumber(phoneNumber);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CodePage()));
                      }
                    },
                  )
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

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    if (text.length == 11) {
      return oldValue;
    }

    var buffer = StringBuffer();
    if (text.length <= 10) {
      for (int i = 0; i < text.length; i++) {
        buffer.write(text[i]);
        var nonZeroIndex = i + 1;
        if (nonZeroIndex % 3 == 0 && nonZeroIndex != text.length && i < 5) {
          buffer.write(
              ' '); // Replace this with anything you want to put after each 4 numbers
        } else if (nonZeroIndex % 2 == 0 &&
            nonZeroIndex != text.length &&
            i >= 5) {
          buffer.write(' ');
        }
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}
