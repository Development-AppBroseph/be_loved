import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/ui/auth/login/code.dart';
import 'package:be_loved/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class PhonePage extends StatefulWidget {
  const PhonePage({Key? key}) : super(key: key);

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  FocusNode focusNode = FocusNode();
  String phoneNumber = '';
  String? error;
  TextEditingController phoneController = TextEditingController();

  final _streamController = StreamController<bool>();

  final _scrollController = ScrollController();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void _sendCode() =>
      BlocProvider.of<AuthBloc>(context).add(SendPhone(phoneNumber));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
      if (current is PhoneSuccess) {
        error = null;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CodePage(),
          ),
        ).then((value) {
          if (phoneNumber.length == 12) {
            BlocProvider.of<AuthBloc>(context).add(TextFieldFilled(true));
          }
        });
      }
      if (current is PhoneError) error = current.error;
      return true;
    }, builder: (context, state) {
      focusNode.addListener(() {
        _streamController.sink.add(focusNode.hasFocus);
      });
      var bloc = BlocProvider.of<AuthBloc>(context);

      return Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   toolbarHeight: 80.sp,
        //   backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
        // ),
        body: StreamBuilder<bool>(
            initialData: false,
            stream: _streamController.stream,
            builder: (context, snapshot) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  // padding: EdgeInsets.only(top: 0.15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 253.h),
                      AnimatedContainer(
                        curve: Curves.easeInOutQuint,
                        duration: const Duration(milliseconds: 600),
                        height: snapshot.data! ? 169.h : 253.h,
                      ),
                      Text(
                        'Войти по номеру телефона',
                        style: GoogleFonts.inter(
                          fontSize: 35.sp,
                          height: 1.1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Войти в уже существующий аккаунт,\nили создать новый',
                        style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          color: const Color.fromRGBO(137, 137, 137, 1.0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 37.h, bottom: 5.h),
                        child: Container(
                          height: 70.h,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset('assets/images/code.png'),
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                '+7',
                                style: GoogleFonts.inter(
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 12.w),
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
                                  onTap: () {
                                    Future.delayed(
                                        const Duration(milliseconds: 600), () {
                                      _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease,
                                      );
                                    });
                                  },
                                  controller: phoneController,
                                  style: GoogleFonts.inter(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  onChanged: (value) {
                                    phoneNumber =
                                        '+7${value.replaceAll(RegExp(' '), '')}';
                                    if (value.length > 12 &&
                                        value.substring(0, 1) == '9') {
                                      BlocProvider.of<AuthBloc>(context)
                                          .add(TextFieldFilled(true));
                                      focusNode.unfocus();
                                    } else {
                                      BlocProvider.of<AuthBloc>(context)
                                          .add(TextFieldFilled(false));
                                    }
                                  },
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    alignLabelWithHint: true,
                                    border: InputBorder.none,
                                    hintText: '900 000 00 00',
                                    hintStyle: GoogleFonts.inter(
                                      fontSize: 25.sp,
                                      color: const Color.fromRGBO(
                                          150, 150, 150, 1),
                                      fontWeight: FontWeight.w700,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
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
                      SizedBox(height: 61.h),
                      CustomButton(
                        color: const Color.fromRGBO(32, 203, 131, 1.0),
                        text: 'Продолжить',
                        // validate: state is TextFieldSuccess ? true : false,
                        textColor: Colors.white,
                        onPressed: () {
                          _sendCode();
                          focusNode.unfocus();
                        },
                      ),
                      // CustomAnimationButton(
                      //   text: 'Продолжить',
                      //   border: Border.all(
                      //       color: const Color.fromRGBO(32, 203, 131, 1.0),
                      //       width: 2.sp),
                      //   onPressed: _sendCode,
                      //   state: phoneNumber.isNotEmpty && phoneNumber.length == 12,
                      // )
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              );
            }),
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
    if (text.length <= 15) {
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
