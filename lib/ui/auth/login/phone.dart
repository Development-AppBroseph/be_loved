import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/helpers/constants.dart';
import 'package:be_loved/ui/auth/login/code.dart';
import 'package:be_loved/widgets/buttons/custom_animation_button.dart';
import 'package:be_loved/widgets/buttons/custom_button.dart';
import 'package:be_loved/widgets/alerts/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({Key? key}) : super(key: key);

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  FocusNode focusNode = FocusNode();
  String phoneNumber = '';
  // AppData appData = AppData('');

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void _sendCode() {
    if (phoneNumber.length == 12) {
      BlocProvider.of<AuthBloc>(context).add(SendPhone(phoneNumber));
    } else if (phoneNumber.isEmpty) {
      StandartSnackBar.show(
        'Номер телефона не заполнен',
        SnackBarStatus(Icons.error, redColor),
      );
      return;
    } else {
      StandartSnackBar.show(
        'Неправильно указан номер телефона',
        SnackBarStatus(Icons.error, redColor),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
      if (current is PhoneSuccess) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CodePage(),
          ),
        );
      }
      return true;
    }, builder: (context, state) {
      if (state is PhoneSuccess) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => CodePage(),
        //   ),
        // );
        // print('success: ${state.code}');
      }
      if (state is PhoneError) {}
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 80.sp,
          backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
        ),
        body: SafeArea(
            bottom: true,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
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
                      padding: EdgeInsets.only(top: 37.h, bottom: 61.h),
                      child: Container(
                        height: 70.h,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(10),
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
                                  phoneNumber =
                                      '+7${value.replaceAll(RegExp(' '), '')}';
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
                    CustomAnimationButton(
                      text: 'Продолжить',
                      border: Border.all(
                          color: const Color.fromRGBO(32, 203, 131, 1.0),
                          width: 2.sp),
                      onPressed: _sendCode,
                      state: phoneNumber.isNotEmpty && phoneNumber.length == 12,
                    )
                  ],
                ),
              ),
            )),
      );
    });
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
