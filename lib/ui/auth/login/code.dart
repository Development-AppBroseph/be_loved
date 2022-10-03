import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/helpers/constants.dart';
import 'package:be_loved/core/helpers/enums.dart';
import 'package:be_loved/core/helpers/shared_prefs.dart';
import 'package:be_loved/ui/auth/login/create_account_info.dart';
import 'package:be_loved/ui/auth/login/invite_relation.dart';
import 'package:be_loved/ui/home/home.dart';
import 'package:be_loved/widgets/buttons/custom_animation_button.dart';
import 'package:be_loved/widgets/buttons/custom_button.dart';
import 'package:be_loved/widgets/alerts/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class CodePage extends StatelessWidget {
  CodePage({Key? key}) : super(key: key);

  final FocusNode focusNode = FocusNode();
  int? code;
  String? phone;
  TextEditingController textEditingController = TextEditingController();

  void _checkCode(BuildContext context) {
    if (textEditingController.text.length == 5) {
      if (textEditingController.text == code.toString()) {
        BlocProvider.of<AuthBloc>(context).add(
          CheckUser(phone ?? '', code ?? 0),
        );
      } else {
        if (code == null) {
          StandartSnackBar.show(
            'Срок кода истёк',
            SnackBarStatus(Icons.error, redColor),
          );
        } else {
          StandartSnackBar.show(
            'Код введён неверно',
            SnackBarStatus(Icons.error, redColor),
          );
        }
      }
    } else if (textEditingController.text.isEmpty) {
      StandartSnackBar.show(
        'Введите код',
        SnackBarStatus(Icons.error, redColor),
      );
    } else {
      StandartSnackBar.show(
        'Код введён неверно',
        SnackBarStatus(Icons.error, redColor),
      );
    }
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
          );
        } else {
          BlocProvider.of<AuthBloc>(context).add(GetUser());
          Future.delayed(const Duration(milliseconds: 500), () {
            if (BlocProvider.of<AuthBloc>(context).user?.date == null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InviteRelation(previousPage: () {}),
                ),
              );
            } else {
              MySharedPrefs().setUser(current.token,
                  BlocProvider.of<AuthBloc>(context, listen: false).user!);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
                (route) => false,
              );
            }
          });
        }
      }
      if (current is CodeError) {
        return false;
      }
      return true;
    }, builder: (context, state) {
      if (state is PhoneSuccess) {
        code = state.code;
        phone = state.phone;
      }
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 80.sp,
          backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
          title: Padding(
            padding: EdgeInsets.only(left: 20.w, top: 40.h, right: 6.w),
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
              padding: EdgeInsets.symmetric(horizontal: 25.w),
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
                      padding: EdgeInsets.symmetric(vertical: 44.h),
                      child: SizedBox(
                        height: 70.sp,
                        child: Pinput(
                          showCursor: false,
                          length: 5,
                          controller: textEditingController,
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
                    // if (state is PhoneSuccess)
                    CustomButton(
                      color: accentColor,
                      text: 'Продолжить',
                      textColor: Colors.white,
                      onPressed: () => _checkCode(context),
                    ),
                    SizedBox(height: 17.h),
                    CustomAnimationButton(
                      black: true,
                      text: 'Отправить код снова',
                      // textColor: const Color.fromRGBO(23, 23, 23, 1.0),
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
    });
  }
}
