import 'dart:async';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/auth/presentation/views/login/code.dart';
import 'package:be_loved/features/home/presentation/views/relationships/account/widgets/policy_view.dart';
import 'package:be_loved/features/theme/bloc/theme_bloc.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class PhonePage extends StatefulWidget {
  final String? vkCode;
  const PhonePage({Key? key, this.vkCode}) : super(key: key);

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

  bool isValidate(TextEditingController controller) {
    if (controller.text.length > 12 && controller.text.substring(0, 1) == '9' ) {
      return true;
    }
    return controller.text.isEmpty;
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
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 80,
          backgroundColor: sl<AuthConfig>().idx == 1
              ? ColorStyles.blackColor
              : const Color.fromRGBO(240, 240, 240, 1.0),
          title: Padding(
            padding: EdgeInsets.only(top: 30.h, right: 6.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 55.h,
                width: 55.h,
                alignment: Alignment.center,
                child: IconButton(
                  icon: SvgPicture.asset(
                    SvgImg.back,
                    width: 15,
                    color: ClrStyle.black2CToWhite[sl<AuthConfig>().idx],
                  ),
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        backgroundColor:
            sl<AuthConfig>().idx == 1 ? ColorStyles.blackColor : null,
        body: StreamBuilder<bool>(
            initialData: false,
            stream: _streamController.stream,
            builder: (context, snapshot) {
              return BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, state) {
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
                          height: (snapshot.data! ? 101.h : 203.h),
                        ),
                        Text(
                          'Войти по номеру телефона',
                          style: GoogleFonts.inter(
                              fontSize: 35.sp,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              color: ClrStyle
                                  .black2CToWhite[sl<AuthConfig>().idx]),
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
                            decoration: BoxDecoration(
                              color: isValidate(phoneController)
                                  ? Colors.white
                                  : ColorStyles.validateColor,
                              borderRadius: const BorderRadius.horizontal(
                                left: Radius.circular(10),
                                right: Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child:
                                          Image.asset('assets/images/code.png'),
                                    ),
                                    Container(
                                      height: 70,
                                      width: 34,
                                      decoration: BoxDecoration(
                                        color: isValidate(phoneController)
                                            ? Colors.transparent
                                            : ColorStyles.validateColor
                                                .withOpacity(.3),
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                    ),
                                  ],
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
                                  color:
                                      const Color.fromRGBO(224, 224, 224, 1.0),
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
                                          const Duration(milliseconds: 600),
                                          () {
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
                                      setState(() {
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
                                      });
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
                        SizedBox(height: 16.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PolicyView(),
                              ),
                            );
                          },
                          child: Text.rich(
                            TextSpan(
                              text: 'Продолжая, вы соглашаетесь с ',
                              style: TextStyles(context).black_15_w700.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromRGBO(
                                        137, 137, 137, 1.0),
                                  ),
                              children: const [
                                TextSpan(
                                  text: 'Политикой Конфиденциальности',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                );
              });
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
