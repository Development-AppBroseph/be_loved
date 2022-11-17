import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/bloc/common_socket/web_socket_bloc.dart';
import 'package:be_loved/core/services/network/config.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/home/presentation/views/home.dart';
import 'package:be_loved/core/widgets/buttons/custom_animation_button.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class InviteFor extends StatefulWidget {
  InviteFor({
    Key? key,
    required this.previewPage,
    required this.nextPage,
    required this.isSwiping,
  }) : super(key: key);

  final VoidCallback previewPage;
  final VoidCallback nextPage;
  bool isSwiping;

  @override
  State<InviteFor> createState() => _InviteForState();
}

class _InviteForState extends State<InviteFor> {
  final streamController = StreamController<int>();
  User? love;
  bool _accepted = false;
  int start = 30;
  Timer? _timer;
  Timer? timerSecond;
  bool _opened = false;

  @override
  void initState() {
    _getUser(context);
    super.initState();
    startTimer();

    love = BlocProvider.of<AuthBloc>(context, listen: false).user?.love;
    Future.delayed(const Duration(milliseconds: 300), () {
      _opened = true;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    timerSecond?.cancel();
    super.dispose();
  }

  void _getUser(BuildContext context) {
    // timerSecond = Timer.periodic(const Duration(seconds: 5), (timer) {
    BlocProvider.of<AuthBloc>(context, listen: false).add(GetUser());
    // });
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timer != null) {
          if (start == 0) {
            setState(() {
              timer.cancel();
            });
            BlocProvider.of<AuthBloc>(context).add(DeleteInviteUser());
            // Navigator.pop(context);
            // print('object previewpage1');
            // widget.previewPage();
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
  Widget build(BuildContext context) {
    return BlocBuilder<WebSocketBloc, WebSocketState>(
        buildWhen: (previous, current) {
          print('object sokect state ${current}');
      if (current is WebSocketInviteCloseState) {
        widget.previewPage();
      }
      if (current is WebSocketStartRelatioinshipsState) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
          (route) => false,
        );
        return true;
      }
      if (current is WebSocketInviteAcceptState) {
        _timer?.cancel();
        _timer = null;
        _accepted = true;
        return true;
      }
      return false;
    }, builder: (context, snapshot) {
      return BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
        // if (current is ReletionshipsError) {
        //   if (!widget.isSwiping) {
        //     widget.previewPage();
        //   }
        //   _opened = false;
        // }
        if (current is GetUserSuccess) {
          love = current.user.love;
          return true;
        }
        // // if (current is InviteAccepted) {
        //   // _timer?.cancel();
        //   // _timer = null;
        //   // _accepted = true;
        // //   return true;
        // // }
        // if (current is ReletionshipsStarted) {
        //   _timer?.cancel();
        //   timerSecond?.cancel();
        //   _timer = null;
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => HomePage(),
        //   ),
        //   (route) => false,
        // );
        // }
        return false;
      }, builder: (context, state) {
        // print('websocket message builder AuthBloc ${state}');
        // if (state is ReletionshipsAccepted) {
        //   _timer?.cancel();
        //   timerSecond?.cancel();
        //   _timer = null;
        //   Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => HomePage(),
        //     ),
        //     (route) => false,
        //   );
        // }
        var bloc = BlocProvider.of<AuthBloc>(context);
        return Scaffold(
          backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
          body: Stack(
            children: [
              AnimatedOpacity(
                curve: Curves.easeInOutQuint,
                duration: const Duration(milliseconds: 500),
                opacity: _accepted ? 1 : 0,
                child: Center(
                  child: Lottie.asset('assets/animations/loading.json'),
                ),
              ),
              AnimatedOpacity(
                curve: Curves.easeInOutQuint,
                duration: const Duration(milliseconds: 500),
                opacity: _accepted ? 1 : 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 60.h),
                    height: 80.w,
                    child: Column(
                      children: [
                        Text(
                          'Ждемс, пока партнер',
                          style: GoogleFonts.inter(
                            fontSize: 17.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'выбирает дату отношений',
                          style: GoogleFonts.inter(
                            fontSize: 17.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              AnimatedOpacity(
                curve: Curves.easeInOutQuint,
                duration: const Duration(milliseconds: 500),
                opacity: _accepted ? 0 : 1,
                child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.sp),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Приглашение от\n',
                                  style: GoogleFonts.inter(
                                    fontSize: 35.sp,
                                    fontWeight: FontWeight.w800,
                                    color:
                                        const Color.fromRGBO(23, 23, 23, 1.0),
                                  ),
                                ),
                                TextSpan(
                                  text: love?.username,
                                  style: GoogleFonts.inter(
                                    fontSize: 35.sp,
                                    fontWeight: FontWeight.w800,
                                    color:
                                        const Color.fromRGBO(255, 29, 29, 1.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Начало истории?',
                            style: GoogleFonts.inter(
                                fontSize: 15.sp,
                                color: const Color.fromRGBO(137, 137, 137, 1.0),
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.h, bottom: 10.h),
                                      child: Material(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(40.r),
                                          ),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 135.w,
                                          width: 135.w,
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                150, 150, 150, 1.0),
                                          ),
                                          child: bloc.user == null
                                              ? bloc.image != null
                                                  ? Image.file(
                                                      File(bloc.image!.path),
                                                      height: 135.w,
                                                      width: 135.w,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Padding(
                                                      padding:
                                                          EdgeInsets.all(43.h),
                                                      child: SvgPicture.asset(
                                                          SvgImg.camera),
                                                    )
                                              : bloc.user?.me.photo != null
                                                  ? Image.network(
                                                      Config.url.url +
                                                          bloc.user!.me.photo!,
                                                      height: 135.w,
                                                      width: 135.w,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Padding(
                                                      padding:
                                                          EdgeInsets.all(43.h),
                                                      child: SvgPicture.asset(
                                                        SvgImg.camera,
                                                      ),
                                                    ),
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
                                      color:
                                          const Color.fromRGBO(23, 23, 23, 1.0),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(21.w),
                                child: SvgPicture.asset(
                                  SvgImg.logo,
                                  width: 66.w,
                                  height: 56.43.w,
                                ),
                              ),
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.h, bottom: 10.h),
                                      child: Material(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(40.r),
                                          ),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                        child: Container(
                                          alignment: Alignment.center,
                                          // padding: EdgeInsets.all(43.h),
                                          height: 135.w,
                                          width: 135.w,
                                          decoration: const BoxDecoration(
                                            color: Color.fromRGBO(
                                                150, 150, 150, 1.0),
                                          ),
                                          child: love?.photo != null
                                              ? Image.network(
                                                  Config.url.url + love!.photo!,
                                                  height: 135.w,
                                                  width: 135.w,
                                                  fit: BoxFit.cover,
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.all(43.h),
                                                  child: SvgPicture.asset(
                                                    SvgImg.camera,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    love?.username ?? '',
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          const Color.fromRGBO(23, 23, 23, 1.0),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 60.sp,
                            width: 0.78.sw,
                            child: TextField(
                              style: GoogleFonts.inter(
                                fontSize: 25.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromRGBO(150, 150, 150, 1.0),
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20),
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          CustomAnimationButton(
                            text: 'Зажми, чтобы принять',
                            onPressed: () async {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(AcceptReletionships());
                            },
                          ),
                          SizedBox(height: 38.h),
                          // if (bloc.user?.status != 'Принято')
                          CustomButton(
                            color: ColorStyles.redColor,
                            text:
                                'Отменить 0:${start < 10 ? '0$start' : start}',
                            textColor: Colors.white,
                            validate: true,
                            onPressed: () {
                              // widget.previewPage();
                              // widget.previewPage();

                              BlocProvider.of<AuthBloc>(context, listen: false)
                                  .add(DeleteInviteUser());
                            },
                          ),
                          // SizedBox(height: 50.h),
                          const Spacer(
                            flex: 2,
                          ),

                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOutQuint,
                            opacity: _opened ? 1 : 0,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Свайп для отмены',
                                    style: GoogleFonts.inter(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromRGBO(
                                            150, 150, 150, 1.0)),
                                  ),
                                  Transform.rotate(
                                    angle: -pi / 2,
                                    child: SvgPicture.asset(
                                      SvgImg.back,
                                      width: 15.sp,
                                      color: const Color.fromRGBO(
                                          150, 150, 150, 1.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 55.h),
                          // const Spacer(),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        );
      });
    });
  }

  AppBar appBar(BuildContext context) {
    int indexPage = 4;
    return AppBar(
      elevation: 0,
      toolbarHeight: 80.sp,
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
      title: Padding(
        padding: EdgeInsets.only(left: 20.sp, top: 40.sp, right: 6.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(
                SvgImg.back,
                width: 15.sp,
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
                              ? Colors.black
                              : Colors.white,
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
