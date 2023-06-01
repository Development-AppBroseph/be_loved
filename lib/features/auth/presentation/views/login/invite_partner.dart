import 'dart:async';
import 'dart:io';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/bloc/common_socket/web_socket_bloc.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/auth/presentation/views/login/phone.dart';
import 'package:be_loved/features/auth/presentation/views/login/relationships.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:get/get.dart' as Get;
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class InvitePartner extends StatefulWidget {
  const InvitePartner(
      {Key? key,
      required this.nextPage,
      this.isParting = false,
      required this.previousPage,
      required this.streamController})
      : super(key: key);

  final StreamController streamController;
  final VoidCallback nextPage;
  final bool isParting;
  final VoidCallback previousPage;

  @override
  State<InvitePartner> createState() => _InvitePartnerState();
}

class _InvitePartnerState extends State<InvitePartner> {
  Timer? _timer;
  Timer? _timerSearching;
  int start = 30;
  bool isValidate = true;
  bool timerIsStarted = false;
  bool inviteUser = true;

  final _scrollController = ScrollController();
  FocusNode focusNode = FocusNode();

  final _streamController = StreamController<bool>();

  final _phoneController = TextEditingController();

  void _inviteUser(BuildContext context) => BlocProvider.of<AuthBloc>(context)
      .add(InviteUser('+7${_phoneController.text.replaceAll(' ', '')}'));

  @override
  void initState() {
    startTimer();
    _timer?.cancel();
    // _startSearch(context);
    BlocProvider.of<AuthBloc>(context).add(DeleteInviteUser());
    if (widget.isParting) {
      BlocProvider.of<AuthBloc>(context).user!.love = null;
      BlocProvider.of<AuthBloc>(context).token = sl<AuthConfig>().token!;
      BlocProvider.of<WebSocketBloc>(context)
          .add(WebSocketEvent(sl<AuthConfig>().token!));
    }
    super.initState();
  }

  TextEditingController textEditingControllerUp = TextEditingController();
  TextEditingController textEditingControllerDown = TextEditingController();

  void startTimer() {
    start = 30;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timer != null) {
          if (start == 0) {
            setState(() {
              // BlocProvider.of<AuthBloc>(context).add(DeleteInviteUser());
              // BlocProvider.of<AuthBloc>(context).add(
              //   CheckIsUserPhone(
              //     '7${_phoneController.text.replaceAll(' ', '')}',
              //   ),
              // );

              isValidate = true;
              timer.cancel();
            });
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
    _timerSearching?.cancel();
    super.dispose();
  }

  // void _startSearch(BuildContext context) {
  //   _timerSearching = Timer.periodic(const Duration(seconds: 5), (timer) {
  //     BlocProvider.of<AuthBloc>(context, listen: false).add(SearchUser());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WebSocketBloc, WebSocketState>(
      buildWhen: (previous, current) {
        if (current is WebSocketInviteGetState) {
          widget.nextPage();
          return false;
        }
        if (current is WebSocketInviteCloseState) {
          BlocProvider.of<AuthBloc>(context).user?.love = null;
          setState(() {
            timerIsStarted = false;
            isValidate = true;
          });
          _timer?.cancel();
          return false;
        }
        if (current is WebSocketInviteAcceptState) {
          _timer?.cancel();
          focusNode.unfocus();
          Get.Get.to(
            RelationShips(previewPage: () {}, prevPage: () {}),
            duration: const Duration(seconds: 1),
            transition: Get.Transition.rightToLeft,
          )?.then((value) {
            setState(() {
              timerIsStarted = false;
              isValidate = true;
            });
            _timer?.cancel();
            // start = 30;
            BlocProvider.of<AuthBloc>(context).add(DeleteInviteUser());
            BlocProvider.of<AuthBloc>(context).user?.love = null;
          });
        }
        return false;
      },
      builder: (context, snapshot) {
        return BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) {
            // // printError(info: current.toString());
            // // print(
            // //     'objectobj ${current} ${_phoneController.text.length} ${isValidate}');
            // // if (current is GetUserError) {
            // //   inviteUser = true;
            // // }

            // if (current is InviteSuccess) {
            //   inviteUser = false;
            //   if (_timer != null) {
            //     if (!_timer!.isActive) {
            //       startTimer();
            //     }
            //   }
            //   // StandartSnackBar.show(
            //   //   'Приглашение успешно отправлено',
            //   //   SnackBarStatus(Icons.done, Colors.green),
            //   // );
            // }
            // if (current is ReletionshipsError) {
            //   _timer?.cancel();
            // }
            // // if (current is InviteAccepted &&
            // //     current.fromYou &&
            // //     previous is InviteAccepted == false &&
            // //     previous is AuthLoading == false) {
            // //   printInfo(info: 'CURRENT IS: $current');
            // //   printInfo(info: 'PREVIOUS IS: $previous');
            // //   _timer?.cancel();
            // //   focusNode.unfocus();
            // //   Get.Get.to(
            // //     RelationShips(previewPage: () {}, prevPage: () {}),
            // //     duration: const Duration(seconds: 1),
            // //     transition: Get.Transition.rightToLeft,
            // //   )?.then((value) {
            // //     setState(() {
            // //       timerIsStarted = false;
            // //       isValidate = true;
            // //     });
            // //     _timer?.cancel();
            // //     // start = 30;
            // //     BlocProvider.of<AuthBloc>(context).add(DeleteInviteUser());
            // //   });
            // //   // widget.previousPage();
            // //   // Navigator.push(
            // //   //   context,
            // //   //   MaterialPageRoute(
            // //   //     builder: (context) => RelationShips(
            // //   //       previewPage: () {},
            // //   //       prevPage: () {},
            // //   //     ),
            // //   //   ),
            // //   // ).then((value) => _startSearch(context));
            // // }
            // if (current is InviteError) {
            //   inviteUser = false;
            //   _timer?.cancel();
            //   // StandartSnackBar.show(
            //   //   'Приглашение не удалось отправить',
            //   //   SnackBarStatus(Icons.error, redColor),
            //   // );
            // }
            // if (current is CheckIsUserExistError) {
            //   inviteUser = false;
            //   // StandartSnackBar.show(
            //   //   'Приглашение не удалось отправить',
            //   //   SnackBarStatus(Icons.error, redColor),
            //   // );
            // }
            // if (current is CheckIsUserExistSuccess) {
            //   inviteUser = true;
            //   // StandartSnackBar.show(
            //   //   'Приглашение не удалось отправить',
            //   //   SnackBarStatus(Icons.error, redColor),
            //   // );
            // }
            // if (current is ReceiveInvite && previous is ReceiveInvite == false) {
            //   _timer?.cancel();
            //   widget.nextPage();
            //   focusNode.unfocus();
            //   // Get.Get.to(
            //   //   InviteFor(
            //   //       previewPage: () {
            //   //         BlocProvider.of<AuthBloc>(context).add(DeleteInviteUser());
            //   //       },
            //   //       nextPage: () {}),
            //   //   duration: const Duration(seconds: 1),
            //   //   transition: Get.Transition.upToDown,
            //   // )?.then((value) => _startSearch(context));
            //   // Navigator.push(
            //   //   context,
            //   //   MaterialPageRoute(
            //   //     builder: (context) => InviteForStartRelationship(nextPage: () {}),
            //   //     fullscreenDialog: true,
            //   //   ),
            //   // ).then((value) => _startSearch(context));
            // }
            // if (current is DeleteInviteSuccess) {
            //   BlocProvider.of<AuthBloc>(context).add(
            //       CheckIsUserPhone('7${_phoneController.text.replaceAll(' ', '')}'));
            // }

            return false;
          },
          builder: (context, state) {
            // print(MediaQuery.of(context).viewInsets.bottom);
            focusNode.addListener(() {
              _streamController.sink.add(focusNode.hasFocus);
            });
            var bloc = BlocProvider.of<AuthBloc>(context);
            return Scaffold(
              appBar: appBar(context),
              backgroundColor: sl<AuthConfig>().idx == 1
                  ? ColorStyles.blackColor
                  : const Color.fromRGBO(240, 240, 240, 1.0),
              body: StreamBuilder<bool>(
                initialData: false,
                stream: _streamController.stream,
                builder: (context, snapshot) {
                  return GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    child: SafeArea(
                      bottom: false,
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            curve: Curves.easeInOutQuint,
                            duration: const Duration(milliseconds: 600),
                            margin: EdgeInsets.only(
                                left: 24.sp,
                                right: 24.sp,
                                top: snapshot.data! ? 32.68.h : 51.68.h),
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(top: 0.sh),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Пригласи ',
                                          style: GoogleFonts.inter(
                                            fontSize: 35.sp,
                                            fontWeight: FontWeight.w800,
                                            color: ClrStyle.black2CToWhite[
                                                sl<AuthConfig>().idx],
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'партнёра',
                                          style: GoogleFonts.inter(
                                            fontSize: 35.sp,
                                            fontWeight: FontWeight.w800,
                                            color: const Color.fromRGBO(
                                                255, 29, 29, 1.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Чтобы пригласить партнера у него должно быть загружено приложение и открыт этот экран',
                                    style: GoogleFonts.inter(
                                      fontSize: 15.sp,
                                      color: const Color.fromRGBO(
                                          137, 137, 137, 1.0),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  AnimatedContainer(
                                    curve: Curves.easeInOutQuint,
                                    duration: const Duration(milliseconds: 600),
                                    height: snapshot.data! ? 20.h : 59.h,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: 135.h,
                                            height: 135.h,
                                            margin: EdgeInsets.only(
                                              bottom: 10.h,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                // bloc.add(EditUserInfo());
                                              },
                                              child: Material(
                                                color: const Color.fromRGBO(
                                                    150, 150, 150, 1),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(40.r),
                                                  ),
                                                ),
                                                clipBehavior: Clip.hardEdge,
                                                child: bloc.user != null
                                                    ? bloc.user?.me.photo !=
                                                            null
                                                        ? Image.network(
                                                            Config.url.url +
                                                                bloc.user!.me
                                                                    .photo!,
                                                            width: 135.w,
                                                            height: 135.h,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    43.h),
                                                            child: SvgPicture
                                                                .asset(
                                                              SvgImg.camera,
                                                            ),
                                                          )
                                                    : bloc.image == null
                                                        ? Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    43.h),
                                                            child: SvgPicture
                                                                .asset(SvgImg
                                                                    .camera),
                                                          )
                                                        : Image.file(
                                                            File(bloc
                                                                .image!.path),
                                                            width: 135.w,
                                                            height: 135.h,
                                                            fit: BoxFit.cover,
                                                          ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            bloc.user != null
                                                ? bloc.user!.me.username
                                                : bloc.nickname.toString(),
                                            style: GoogleFonts.inter(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromRGBO(
                                                  23, 23, 23, 1.0),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(21.w),
                                        child: SvgPicture.asset(
                                          SvgImg.logo,
                                          width: 66.w,
                                          height: 56.43.h,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              width: 135.h,
                                              height: 135.h,
                                              margin:
                                                  EdgeInsets.only(bottom: 10.h),
                                              child: Material(
                                                color: const Color.fromRGBO(
                                                  150,
                                                  150,
                                                  150,
                                                  1,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(40.r),
                                                  ),
                                                ),
                                                clipBehavior: Clip.hardEdge,
                                                child: bloc.user?.love?.photo !=
                                                            null &&
                                                        snapshot
                                                            is WebSocketInviteGetState
                                                    ? Image.network(
                                                        Config.url.url +
                                                            bloc.user!.love!
                                                                .photo!,
                                                        width: 135.w,
                                                        height: 135.h,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Padding(
                                                        padding: EdgeInsets.all(
                                                            43.h),
                                                        child: SvgPicture.asset(
                                                          SvgImg.camera,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            bloc.user?.love?.username ?? '',
                                            style: GoogleFonts.inter(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromRGBO(
                                                  23, 23, 23, 1.0),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  AnimatedContainer(
                                    curve: Curves.easeInOutQuint,
                                    duration: const Duration(milliseconds: 600),
                                    height: snapshot.data! ? 25.h : 44.h,
                                  ),
                                  Container(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.asset(
                                              'assets/images/code.png'),
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
                                          color: const Color.fromRGBO(
                                              224, 224, 224, 1.0),
                                        ),
                                        SizedBox(
                                          width: 12.w,
                                        ),
                                        Container(
                                          width: 0.6.sw,
                                          alignment: Alignment.center,
                                          child: TextField(
                                            controller: _phoneController,
                                            style: GoogleFonts.inter(
                                              fontSize: 25.sp,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            onTap: () {
                                              // Future.delayed(
                                              //     const Duration(milliseconds: 600), () {
                                              //   _scrollController.animateTo(
                                              //     5,
                                              //     duration:
                                              //         const Duration(milliseconds: 500),
                                              //     curve: Curves.ease,
                                              //   );
                                              // });
                                            },
                                            onChanged: (value) {
                                              if (_phoneController.length ==
                                                  12) {
                                                print('123');
                                                setState(() {
                                                  isValidate = true;
                                                });
                                              }
                                              if (value.length == 13 &&
                                                  bloc.user?.love == null) {
                                                inviteUser = true;
                                                // bloc.add(TextFieldFilled(true));
                                                // print(
                                                //     'object ${text.substring(1, text.length)}');
                                                focusNode.unfocus();
                                                if (bloc.user?.love == null) {
                                                  bloc.add(CheckIsUserPhone(
                                                      '7${_phoneController.text.replaceAll(' ', '')}'));
                                                }
                                                printError(
                                                    info:
                                                        '+7${_phoneController.text.replaceAll(' ', '')}');
                                              } else {
                                                if (value.length == 13) {
                                                  focusNode.unfocus();
                                                }
                                                bloc.add(
                                                    TextFieldFilled(false));
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
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              CustomInputFormatter(),
                                            ],
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  AnimatedContainer(
                                    curve: Curves.easeInOutQuint,
                                    duration: const Duration(milliseconds: 600),
                                    height: snapshot.data! ? 24.h : 57.h,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          color: const Color.fromRGBO(
                                              32, 203, 131, 1.0),
                                          text: 'Пригласить',
                                          validate:
                                              (_phoneController.text.length ==
                                                      13) &&
                                                  isValidate,
                                          code: false,
                                          textColor: Colors.white,
                                          onPressed: () async {
                                            setState(() {
                                              timerIsStarted = true;
                                            });
                                            // _timer.cancel();
                                            print(timerIsStarted);
                                            print(_timer?.isActive);
                                            if (bloc.user?.me.phoneNumber !=
                                                _phoneController.text) {
                                              _inviteUser(context);
                                              if (_timer != null) {
                                                if (!_timer!.isActive) {
                                                  startTimer();
                                                }
                                              }
                                            }
                                            setState(() {
                                              isValidate = false;
                                            });
                                            // startTimer();
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      SizedBox(
                                        width: 60.w,
                                        child: CustomButton(
                                          color: const Color.fromRGBO(
                                              32, 203, 131, 1.0),
                                          svg: SvgImg.persons,
                                          text: '',
                                          validate: bloc.user?.love == null,
                                          code: false,
                                          textColor: Colors.white,
                                          onPressed: () async {
                                            if (await FlutterContactPicker
                                                .hasPermission()) {
                                              final PhoneContact contact =
                                                  await FlutterContactPicker
                                                      .pickPhoneContact();
                                              if (contact.phoneNumber?.number !=
                                                  null) {
                                                String reversedPhone = contact
                                                    .phoneNumber!.number!
                                                    .split('')
                                                    .reversed
                                                    .join('');
                                                String phone = '';
                                                for (var i = 0;
                                                    i < reversedPhone.length;
                                                    i++) {
                                                  if (phone.length >= 13) {
                                                    break;
                                                  }
                                                  if (double.tryParse(
                                                          reversedPhone[i]) !=
                                                      null) {
                                                    if (phone.length == 2 ||
                                                        phone.length == 5 ||
                                                        phone.length == 9) {
                                                      phone += ' ';
                                                    }
                                                    phone += reversedPhone[i];
                                                  }
                                                }
                                                setState(() {
                                                  _phoneController.text = phone
                                                      .split('')
                                                      .reversed
                                                      .join('');
                                                  if (_phoneController
                                                              .text.length ==
                                                          13 &&
                                                      bloc.user?.love == null) {
                                                    inviteUser = true;
                                                  }
                                                });
                                              }
                                            } else {
                                              FlutterContactPicker
                                                  .requestPermission();
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  // CustomAnimationButton(
                                  //   text: 'Продолжить',
                                  //   border: Border.all(
                                  //     color: const Color.fromRGBO(32, 203, 131, 1.0),
                                  //     width: 2.sp),
                                  //   onPressed: () async {
                                  //     // nextPage();
                                  //     _inviteUser(context);
                                  //   },
                                  // ),
                                  SizedBox(height: 17.h),
                                  SizedBox(
                                    height: 400.h,
                                    child: AnimatedAlign(
                                      curve: Curves.easeInOutQuint,
                                      alignment: bloc.user?.love != null &&
                                              bloc.user!.fromYou!
                                          ? Alignment.topLeft
                                          : Alignment.bottomCenter,
                                      duration:
                                          const Duration(milliseconds: 1200),
                                      child: CustomButton(
                                        visible: true,
                                        color: ColorStyles.redColor,
                                        text: _getTime(),
                                        textColor: Colors.white,
                                        validate: true,
                                        onPressed: () async {
                                          // nextPage();
                                          setState(() {
                                            timerIsStarted = false;
                                            isValidate = true;
                                          });
                                          _timer?.cancel();
                                          // start = 30;
                                          BlocProvider.of<AuthBloc>(context)
                                              .add(DeleteInviteUser());
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  String _getTime() {
    if (start < 10) {
      return 'Отменить 0:0$start';
    } else {
      return 'Отменить 0:$start';
    }
  }

  AppBar appBar(BuildContext context) {
    int indexPage = 3;
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
            if (widget.isParting)
              GestureDetector(
                onTap: () {
                  context.read<AuthBloc>().add(LogOut(context));
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      SvgImg.logout,
                      color: ClrStyle.black2CToWhite[sl<AuthConfig>().idx],
                      width: 46.w,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'Выйти',
                      style: TextStyles(context).black_20_w800,
                    )
                  ],
                ),
              )
            else
              Container(
                height: 55.h,
                width: 55.h,
                margin: const EdgeInsets.only(top: 20),
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
                    context.read<WebSocketBloc>().add(WebSocketCloseEvent());
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
                              ? ClrStyle.black17ToWhite[sl<AuthConfig>().idx]
                              : ClrStyle.whiteToBlack2C[sl<AuthConfig>().idx],
                      border: indexPage + 1 > index
                          ? null
                          : Border.all(
                              width: 1,
                              color: ColorStyles.redColor,
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

// class CustomInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     var text = newValue.text;

//     if (newValue.selection.baseOffset == 0) {
//       return newValue;
//     }

//     if (text.length == 11) {
//       return oldValue;
//     }

//     var buffer = StringBuffer();
//     if (text.length <= 16) {
//       for (int i = 0; i < text.length; i++) {
//         buffer.write(text[i]);
//         var nonZeroIndex = i + 1;
//         if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length && i < 5) {
//           buffer.write(
//               ' '); // Replace this with anything you want to put after each 4 numbers
//         } else if (nonZeroIndex % 2 == 0 &&
//             nonZeroIndex != text.length &&
//             i >= 5) {
//           buffer.write(' ');
//         }
//       }
//     }

//     var string = buffer.toString();
//     return newValue.copyWith(
//         text: string,
//         selection: TextSelection.collapsed(offset: string.length));
//   }
// }
