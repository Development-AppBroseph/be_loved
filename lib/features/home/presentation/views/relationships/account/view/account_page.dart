import 'dart:async';
import 'dart:io';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/auth/presentation/views/login/phone.dart';
import 'package:be_loved/features/home/presentation/views/relationships/account/controller/account_page_cubit.dart';
import 'package:be_loved/features/home/presentation/views/relationships/account/controller/account_page_state.dart';
import 'package:be_loved/features/home/presentation/views/relationships/account/widgets/avatar_modal.dart';
import 'package:be_loved/features/home/presentation/views/relationships/account/widgets/mirror_image.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class AccountPage extends StatelessWidget {
  final VoidCallback prevPage;
  AccountPage({Key? key, required this.prevPage}) : super(key: key);

  int countPage = 0;

  FocusNode focusNodePhone = FocusNode();
  FocusNode focusNodeCode = FocusNode();
  int? code;
  TextEditingController textEditingControllerUp = TextEditingController();
  TextEditingController textEditingControllerDown = TextEditingController();
  String phoneNumber = '';
  bool resendCode = false;
  final _streamController = StreamController<int>();
  final _streamControllerCarousel = StreamController<double>();
  final _scrollController = ScrollController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  PageController controller = PageController();

  File? _image;
  bool isMirror = false;
  // final headers["user"] = sl<AuthConfig>().user;
  // Future _pickImage(ImageSource source) async {
  //   try {
  //     final image = await ImagePicker().pickImage(source: source);
  //     if (image != null) {
  //       File? img = File(image.path);
  //       setState(() {
  //         _image = img;
  //       });
  //       Navigator.of(context).pop();
  //     }
  //   } on PlatformException catch (e) {
  //     print(e);
  //     Navigator.of(context).pop();
  //   }
  // }

  void mirror(BuildContext context) {
    !isMirror ? isMirror = true : isMirror = false;
    Navigator.of(context).pop();
  }

  // @override
  // void dispose() {
  //   focusNodePhone.dispose();
  //   focusNodeCode.dispose();
  //   _streamController.close();
  //   _streamControllerCarousel.close();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    // LinearGradient gradientText = const LinearGradient(
    //   colors: [
    //     Color.fromRGBO(255, 255, 255, 1),
    //     Color.fromRGBO(255, 255, 255, 0),
    //   ],
    //   transform: GradientRotation(pi / 2),
    // );
    return BlocBuilder<AccountCubit, AccountPageState>(
        builder: (context, state) {
      return SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const ClampingScrollPhysics(),
        controller: _scrollController,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: StreamBuilder<int>(
                stream: _streamController.stream,
                initialData: 0,
                builder: (context, snapshot) {
                  return Stack(
                    children: [
                      Image.asset(Img.backgroungProfile),
                      Padding(
                        padding: EdgeInsets.only(left: 15.w, top: 76.h),
                        child: GestureDetector(
                          onTap: prevPage,
                          child: Row(
                            children: [
                              SizedBox(
                                height: 55.h,
                                width: 55.w,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      SvgImg.back,
                                      color: Colors.white,
                                      width: 15.w,
                                      height: 26.32,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Назад',
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 186.h),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 135.h),
                                  child: SizedBox(
                                    height: 130.h,
                                    width: 428.w,
                                    child: CupertinoCard(
                                      margin: EdgeInsets.all(0.h),
                                      elevation: 0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Никита Белых',
                                                style: style3.copyWith(
                                                  fontSize: 30.sp,
                                                  color:
                                                      const Color(0xff171717),
                                                  height: 1.h,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8.h, bottom: 5.h),
                                                child: SvgPicture.asset(
                                                  SvgImg.edit,
                                                  color:
                                                      const Color(0xff969696),
                                                  height: 17.h,
                                                  width: 17.w,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 105.h),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20.h),
                                                  child: Text(
                                                    '+7 *** *** 00-00',
                                                    style: style3.copyWith(
                                                      fontSize: 15.sp,
                                                      color: Colors.black,
                                                      height: 1.h,
                                                    ),
                                                  ),
                                                ),
                                                SvgPicture.asset(SvgImg.vkLogo)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                photo(context),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 15.h),
                              child: SizedBox(
                                height: 65.h,
                                width: 428.w,
                                child: CupertinoCard(
                                  margin: EdgeInsets.all(0.h),
                                  elevation: 0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SvgPicture.asset(SvgImg.vkLogo),
                                      Text(
                                        'Привязать страницу VK',
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.add,
                                        color: Color(0xff0077FF),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            AnimatedContainer(
                              height: countPage == 0 ? 310.h : 400.h,
                              width: 430.w,
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOutQuint,
                              padding: EdgeInsets.only(top: 15.h),
                              child: CupertinoCard(
                                margin: EdgeInsets.all(0.h),
                                elevation: 0,
                                padding: EdgeInsets.symmetric(horizontal: 25.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: SingleChildScrollView(
                                  physics: const NeverScrollableScrollPhysics(),
                                  controller: controller,
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 15.h),
                                        child: SizedBox(
                                          height: 309.h,
                                          width: 428.w,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 5.h),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Сменить номер телефона',
                                                  style: TextStyle(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 47.h, bottom: 5.h),
                                                  child: Container(
                                                    height: 70.h,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .horizontal(
                                                        left:
                                                            Radius.circular(10),
                                                        right:
                                                            Radius.circular(10),
                                                      ),
                                                      border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.asset(
                                                              'assets/images/code.png'),
                                                        ),
                                                        SizedBox(width: 12.w),
                                                        Text(
                                                          '+7',
                                                          style:
                                                              GoogleFonts.inter(
                                                            fontSize: 25.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(width: 12.w),
                                                        Container(
                                                          height: 37.h,
                                                          width: 1.w,
                                                          color: const Color
                                                                  .fromRGBO(224,
                                                              224, 224, 1.0),
                                                        ),
                                                        SizedBox(
                                                          width: 12.w,
                                                        ),
                                                        Container(
                                                          width: 0.6.sw,
                                                          alignment:
                                                              Alignment.center,
                                                          child: TextField(
                                                            onTap: () {
                                                              Future.delayed(
                                                                const Duration(
                                                                    milliseconds:
                                                                        600),
                                                                () {
                                                                  _scrollController
                                                                      .animateTo(
                                                                    _scrollController
                                                                        .position
                                                                        .maxScrollExtent,
                                                                    duration:
                                                                        const Duration(
                                                                      milliseconds:
                                                                          400,
                                                                    ),
                                                                    curve: Curves
                                                                        .ease,
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            controller:
                                                                phoneController,
                                                            style: GoogleFonts
                                                                .inter(
                                                              fontSize: 25.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                            onChanged: (value) {
                                                              phoneNumber =
                                                                  '+7${value.replaceAll(RegExp(' '), '')}';
                                                              if (value.length >
                                                                      12 &&
                                                                  value.substring(
                                                                          0,
                                                                          1) ==
                                                                      '9') {
                                                                // BlocProvider.of<AuthBloc>(context)
                                                                //     .add(TextFieldFilled(true));
                                                                // focusNode.unfocus();
                                                              } else {
                                                                // BlocProvider.of<AuthBloc>(context)
                                                                //     .add(TextFieldFilled(false));
                                                              }
                                                            },
                                                            focusNode:
                                                                focusNodePhone,
                                                            decoration:
                                                                InputDecoration(
                                                              alignLabelWithHint:
                                                                  true,
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintText:
                                                                  '900 000 00 00',
                                                              hintStyle:
                                                                  GoogleFonts
                                                                      .inter(
                                                                fontSize: 25.sp,
                                                                color: const Color
                                                                        .fromRGBO(
                                                                    150,
                                                                    150,
                                                                    150,
                                                                    1),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                              floatingLabelBehavior:
                                                                  FloatingLabelBehavior
                                                                      .never,
                                                            ),
                                                            inputFormatters: [
                                                              FilteringTextInputFormatter
                                                                  .digitsOnly,
                                                              CustomInputFormatter(),
                                                            ],
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 35.h),
                                                  child: BlocBuilder<
                                                      AccountCubit,
                                                      AccountPageState>(
                                                    builder: (context, state) {
                                                      return CustomButton(
                                                        validate: true,
                                                        color: const Color
                                                                .fromRGBO(
                                                            32, 203, 131, 1.0),
                                                        text: 'Продолжить',
                                                        // validate: state is TextFieldSuccess ? true : false,
                                                        textColor: Colors.white,
                                                        onPressed: () {
                                                          // _sendCode();
                                                          context
                                                              .read<
                                                                  AccountCubit>()
                                                              .postPhoneNumber(
                                                                  phoneNumber);

                                                          countPage = 1;
                                                          focusNodeCode
                                                              .requestFocus();
                                                          controller
                                                              .animateToPage(
                                                            1,
                                                            duration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        1200),
                                                            curve: Curves.ease,
                                                          );
                                                          Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      200), () {
                                                            _scrollController
                                                                .animateTo(
                                                              _scrollController
                                                                  .position
                                                                  .maxScrollExtent,
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          200),
                                                              curve:
                                                                  Curves.ease,
                                                            );
                                                          });
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 0.w),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // AnimatedContainer(
                                            //     curve: Curves.easeInOutQuint,
                                            //     duration:
                                            //         const Duration(milliseconds: 200),
                                            //     height: 17.h),
                                            Text(
                                              'Введи код подтверждения',
                                              style: GoogleFonts.inter(
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 44.h,
                                            ),
                                            SizedBox(
                                              height: 70.sp,
                                              child: Pinput(
                                                onTap: () {
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 600),
                                                      () {
                                                    _scrollController.animateTo(
                                                      _scrollController.position
                                                          .maxScrollExtent,
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.ease,
                                                    );
                                                  });
                                                },
                                                pinAnimationType:
                                                    PinAnimationType.none,
                                                showCursor: false,
                                                length: 5,
                                                androidSmsAutofillMethod:
                                                    AndroidSmsAutofillMethod
                                                        .smsRetrieverApi,
                                                controller: codeController,
                                                focusNode: focusNodeCode,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                onChanged: (value) {
                                                  if (value.length == 5 &&
                                                      value ==
                                                          code.toString()) {
                                                    // BlocProvider.of<AuthBloc>(context)
                                                    //     .add(TextFieldFilled(true));
                                                    focusNodeCode.unfocus();
                                                  } else {
                                                    // BlocProvider.of<AuthBloc>(context)
                                                    //     .add(TextFieldFilled(false));
                                                  }
                                                },
                                                defaultPinTheme: PinTheme(
                                                  width: 60.sp,
                                                  height: 80.sp,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      )),
                                                  textStyle: GoogleFonts.inter(
                                                    fontSize: 35.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color.fromRGBO(
                                                        23, 23, 23, 1.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 51.h,
                                            ),
                                            BlocBuilder<AccountCubit,
                                                AccountPageState>(
                                              builder: (context, state) {
                                                return CustomButton(
                                                  validate: true,
                                                  color: const Color.fromRGBO(
                                                      32, 203, 131, 1.0),
                                                  text: 'Готово',
                                                  textColor: Colors.white,
                                                  onPressed: () {
                                                    // _checkCode(context);
                                                    context
                                                        .read<AccountCubit>()
                                                        .putUserCode(12345);

                                                    countPage = 0;
                                                    focusNodeCode.unfocus();
                                                    controller.animateToPage(
                                                      0,
                                                      duration: const Duration(
                                                          milliseconds: 1200),
                                                      curve: Curves.ease,
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                            // CustomAnimationButton(
                                            //   text: 'Продолжить',
                                            //   border: Border.all(
                                            //       color:
                                            //       width: 2.sp),
                                            //   onPressed: () => _checkCode(context),
                                            // ),
                                            SizedBox(
                                              height: 17.h,
                                            ),
                                            CustomButton(
                                              // black: true,
                                              validate: true,
                                              code: true,
                                              text: 'Отправить код снова',
                                              border: Border.all(
                                                  color: const Color.fromRGBO(
                                                      23, 23, 23, 1.0),
                                                  width: 2.sp),
                                              onPressed: () {
                                                if (textEditingControllerUp
                                                        .text.length ==
                                                    5) {
                                                  // BlocProvider.of<AuthBloc>(context).add(
                                                  //   TextFieldFilled(true),
                                                  // );
                                                }
                                                resendCode = false;
                                                // if (_timer?.isActive == false) {
                                                //   startTimer();
                                                // }
                                              },
                                              color: Colors.black,
                                              textColor: Colors.white,
                                            ),
                                            SizedBox(height: 47.h),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  // TextStyle style1 = TextStyle(
  //     fontWeight: FontWeight.w700, color: Colors.white, fontSize: 15.sp);
  // TextStyle style2 = TextStyle(
  //     fontWeight: FontWeight.w700, color: Colors.white, fontSize: 30.sp);
  TextStyle style3 = TextStyle(
      fontWeight: FontWeight.w800, color: Colors.white, fontSize: 18.sp);

  Widget photo(BuildContext context) {
    return InkWell(
        onTap: () {
          showModalAvatarChange(context, (newFile, isMir) {
            _image = newFile;
            isMirror = isMir;
          }, _image);
        },
        child: MirrorImage(
          isMirror: isMirror,
          path: _image,
        ));
  }
}
