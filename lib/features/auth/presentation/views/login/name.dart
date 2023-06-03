import 'dart:async';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class InputNamePage extends StatelessWidget {
  InputNamePage({Key? key, required this.nextPage}) : super(key: key);
  String? error;

  final VoidCallback nextPage;
  final _nicknameController = TextEditingController();

  final _scrollController = ScrollController();

  final _streamController = StreamController<bool>();

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
      if (current is NicknameSuccess) {
        error = null;
        nextPage();
      } else if (current is NicknameError) {
        error = current.error;
      }
      return true;
    }, builder: (context, state) {
      focusNode.addListener(() {
        _streamController.sink.add(focusNode.hasFocus);
      });
      return Scaffold(
        appBar: appBar(context),
        backgroundColor: sl<AuthConfig>().idx == 1
            ? ColorStyles.blackColor
            : const Color.fromRGBO(240, 240, 240, 1.0),
        body: StreamBuilder<bool>(
            initialData: false,
            stream: _streamController.stream,
            builder: (context, snapshot) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.sp),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const NeverScrollableScrollPhysics(),
                  // padding: EdgeInsets.only(top: 0.15.sh),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        curve: Curves.easeInOutQuint,
                        duration: const Duration(milliseconds: 600),
                        height: snapshot.data! ? 75.h : 189.h,
                      ),
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Как тебя ',
                                style: GoogleFonts.inter(
                                  fontSize: 35.sp,
                                  fontWeight: FontWeight.w800,
                                  color: ClrStyle
                                      .black2CToWhite[sl<AuthConfig>().idx],
                                )),
                            TextSpan(
                                text: 'зовут?',
                                style: GoogleFonts.inter(
                                    fontSize: 35.sp,
                                    fontWeight: FontWeight.w800,
                                    color: const Color.fromRGBO(
                                        255, 29, 29, 1.0))),
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
                      AnimatedContainer(
                        curve: Curves.easeInOutQuint,
                        duration: const Duration(milliseconds: 600),
                        height: snapshot.data! ? 38.h : 75.h,
                      ),
                      Column(
                        children: [
                          Container(
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
                                  color: Colors.transparent,
                                  child: TextField(
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    textAlignVertical: TextAlignVertical.top,
                                    focusNode: focusNode,
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
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(12),
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9a-zA-Z-А-Яа-я]")),
                                    ],
                                    onChanged: (text) {
                                      if (text.length > 1 &&
                                          !text.contains('  ')) {
                                        BlocProvider.of<AuthBloc>(context)
                                            .add(TextFieldFilled(true));
                                      } else {
                                        BlocProvider.of<AuthBloc>(context)
                                            .add(TextFieldFilled(false));
                                      }
                                    },
                                    controller: _nicknameController,
                                    style: GoogleFonts.inter(
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Арбуз',
                                      hintStyle: GoogleFonts.inter(
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromRGBO(
                                          150,
                                          150,
                                          150,
                                          1.0,
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      AnimatedContainer(
                        curve: Curves.easeInOutQuint,
                        duration: const Duration(milliseconds: 600),
                        height: snapshot.data! ? 43.h : 61.h,
                      ),
                      CustomButton(
                          color: const Color.fromRGBO(32, 203, 131, 1.0),
                          text: 'Продолжить',
                          textColor: Colors.white,
                          onPressed: () {
                            focusNode.unfocus();

                            BlocProvider.of<AuthBloc>(context)
                                .add(SetNickname(_nicknameController.text));
                          }),
                      // CustomAnimationButton(
                      //   text: 'Продолжить',
                      //   border: Border.all(
                      //       color: const Color.fromRGBO(32, 203, 131, 1.0),
                      //       width: 2.sp),
                      //   onPressed: () {
                      //     if (_nicknameController.text.isNotEmpty) {
                      //       BlocProvider.of<AuthBloc>(context).add(SetNickname(_nicknameController.text));
                      //       nextPage();
                      //     }
                      //   },
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            }),
      );
    });
  }

  AppBar appBar(BuildContext context) {
    int indexPage = 1;
    return AppBar(
      elevation: 0,
      toolbarHeight: 80,
      backgroundColor: sl<AuthConfig>().idx == 1
          ? ColorStyles.blackColor
          : const Color.fromRGBO(240, 240, 240, 1.0),
      title: Padding(
        padding: EdgeInsets.only(top: 20.h, right: 6.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
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
                              ? ClrStyle.black2CToWhite[sl<AuthConfig>().idx]
                              : ClrStyle.whiteToBlack2C[sl<AuthConfig>().idx],
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
