import 'dart:async';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/helpers/enums.dart';
import 'package:be_loved/core/helpers/shared_prefs.dart';
import 'package:be_loved/ui/auth/login/create_account_info.dart';
import 'package:be_loved/ui/auth/login/invite_relation.dart';
import 'package:be_loved/ui/home/home.dart';
import 'package:be_loved/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class CodePage extends StatefulWidget {
  const CodePage({Key? key}) : super(key: key);

  @override
  State<CodePage> createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  final FocusNode focusNode = FocusNode();

  int? code;
  int start = 60;
  Timer? _timer;
  String? phone;
  bool resendCode = false;

  final _scrollController = ScrollController();

  TextEditingController textEditingControllerUp = TextEditingController();
  TextEditingController textEditingControllerDown = TextEditingController();

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void _checkCode(BuildContext context) => BlocProvider.of<AuthBloc>(context)
      .add(CheckUser(phone ?? '', textEditingControllerUp.text, code ?? 0));

  void startTimer() {
    start = 60;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timer != null) {
          if (start == 0) {
            setState(() {
              timer.cancel();
            });
            resendCode = true;
            //widget.previewPage();
          } else {
            setState(() {
              start--;
            });
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
      if (current is CodeSuccess) {
        if (current.existUser == ExistUser.notExist) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateAccountInfo(),
            ),
          ).then((value) {
            if (textEditingControllerUp.text.length == 5) {
              BlocProvider.of<AuthBloc>(context).add(TextFieldFilled(true));
            }
          });
        } else {
          BlocProvider.of<AuthBloc>(context).add(GetUser());
          Future.delayed(const Duration(milliseconds: 500), () {
            if (BlocProvider.of<AuthBloc>(context).user?.date == null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InviteRelation(previousPage: () {}),
                ),
              ).then((value) {
                if (textEditingControllerUp.text.length == 5) {
                  BlocProvider.of<AuthBloc>(context).add(TextFieldFilled(true));
                }
              });
            } else {
              MySharedPrefs().setUser(current.token,
                  BlocProvider.of<AuthBloc>(context, listen: false).user!);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
                (route) => false,
              );
            }
          });
        }
      }
      // if (current is CodeError) error = current.error;

      return true;
    }, builder: (context, state) {
      if (state is PhoneSuccess) {
        code = state.code;
        phone = state.phone;
      }
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 80,
          backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
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
                    'assets/icons/back.svg',
                    width: 15,
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
        body: SafeArea(
            bottom: true,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(top: 0.15.sh),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Введи код подтверждения',
                      style: GoogleFonts.inter(
                        fontSize: 35.sp,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'В ближайшее время вам придёт sms-\nсообщение с кодом подтверждения',
                      style: GoogleFonts.inter(
                          fontSize: 15.sp,
                          color: const Color.fromRGBO(137, 137, 137, 1.0),
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 44.h),
                      child: SizedBox(
                        height: 70.sp,
                        child: Pinput(
                          pinAnimationType: PinAnimationType.none,
                          showCursor: false,
                          onTap: () {
                            _scrollController.animateTo(
                              MediaQuery.of(context).size.height / 7,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                          length: 5,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsRetrieverApi,
                          controller: textEditingControllerUp,
                          focusNode: focusNode,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          onChanged: (value) {
                            if (value.length == 5 && value == code.toString()) {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(TextFieldFilled(true));
                              focusNode.unfocus();
                            } else {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(TextFieldFilled(false));
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
                    SizedBox(height: 51.h),
                    CustomButton(
                      color: const Color.fromRGBO(32, 203, 131, 1.0),
                      text: 'Продолжить',
                      textColor: Colors.white,
                      onPressed: () {
                        _checkCode(context);
                        focusNode.unfocus();
                      },
                    ),
                    // CustomAnimationButton(
                    //   text: 'Продолжить',
                    //   border: Border.all(
                    //       color:
                    //       width: 2.sp),
                    //   onPressed: () => _checkCode(context),
                    // ),
                    SizedBox(height: 17.h),
                    CustomButton(
                      // black: true,
                      validate: resendCode,
                      code: true,
                      text: resendCode ? 'Отправить код снова' : _getTime(),
                      border: Border.all(
                          color: const Color.fromRGBO(23, 23, 23, 1.0),
                          width: 2.sp),
                      onPressed: () {
                        if (textEditingControllerUp.text.length == 5) {
                          BlocProvider.of<AuthBloc>(context)
                              .add(TextFieldFilled(true));
                        }
                        resendCode = false;
                        if (_timer?.isActive == false) {
                          startTimer();
                        }
                      },
                      color: Colors.black,
                      textColor: Colors.white,
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            )),
      );
    });
  }

  String _getTime() {
    if (start < 60) {
      return 'Отправить код снова 0:${start < 10 ? '0$start' : start}';
    } else if (start == 120) {
      return 'Отправить код снова 2:00';
    } else {
      return 'Отправить код снова 01:0${start < 10 ? '0${start - 60}' : start - 60}';
    }
  }
}
