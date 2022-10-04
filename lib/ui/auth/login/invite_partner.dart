import 'dart:async';
import 'dart:io';

import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/helpers/constants.dart';
import 'package:be_loved/ui/auth/login/inviteFor_start_relationship.dart';
import 'package:be_loved/ui/auth/login/relationships.dart';
import 'package:be_loved/widgets/buttons/custom_animation_button.dart';
import 'package:be_loved/widgets/buttons/custom_button.dart';
import 'package:be_loved/widgets/alerts/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class InvitePartner extends StatefulWidget {
  const InvitePartner(
      {Key? key, required this.nextPage, required this.previousPage})
      : super(key: key);

  final VoidCallback nextPage;
  final VoidCallback previousPage;

  @override
  State<InvitePartner> createState() => _InvitePartnerState();
}

class _InvitePartnerState extends State<InvitePartner> {
  late Timer _timer;

  final _phoneController = TextEditingController();

  void _inviteUser(BuildContext context) {
    if (_phoneController.text.length == 12) {
      BlocProvider.of<AuthBloc>(context).add(
        InviteUser(_phoneController.text),
      );
    } else {
      StandartSnackBar.show(
        'Укажите номер пользователя',
        SnackBarStatus(Icons.error, redColor),
      );
      return;
    }
  }

  @override
  void initState() {
    _startSearch(context);
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startSearch(BuildContext context) {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      BlocProvider.of<AuthBloc>(context, listen: false).add(SearchUser());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
      if (current is InviteSuccess) {
        // StandartSnackBar.show(
        //   'Приглашение успешно отправлено',
        //   SnackBarStatus(Icons.done, Colors.green),
        // );
      }
      if (current is InviteAccepted && current.fromYou) {
        _timer.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RelationShips(previewPage: () {}, prevPage: () {}),
          ),
        ).then((value) => _startSearch(context));
      }
      if (current is InviteError) {
        StandartSnackBar.show(
          'Приглашение не удалось отправить',
          SnackBarStatus(Icons.error, redColor),
        );
      }
      if (current is ReceiveInvite && previous is ReceiveInvite == false) {
        _timer.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InviteForStartRelationship(nextPage: () {}),
            fullscreenDialog: true,
          ),
        ).then((value) => _startSearch(context));
      }
      return true;
    }, builder: (context, state) {
      var bloc = BlocProvider.of<AuthBloc>(context);
      return Scaffold(
        appBar: appBar(context),
        backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
        body: SafeArea(
            bottom: true,
            child: Stack(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: state is AuthLoading ? 1 : 0,
                  child: Center(
                    child: SvgPicture.asset('assets/icons/logov2.svg'),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: state is AuthLoading ? 0 : 1,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 24.sp, right: 24.sp, top: 0.1.sw),
                    child: SingleChildScrollView(
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
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromRGBO(23, 23, 23, 1.0),
                                  ),
                                ),
                                TextSpan(
                                  text: 'партнёра',
                                  style: GoogleFonts.inter(
                                    fontSize: 35.sp,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromRGBO(255, 29, 29, 1.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Позови партнёра на этот экран, введи его\nникнейм, и ожидай принятия приглашения',
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              color: const Color.fromRGBO(137, 137, 137, 1.0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.h, bottom: 10.h),
                                      child: GestureDetector(
                                        onTap: () {
                                          bloc.add(EditUserInfo());
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(35.sp),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 135.h,
                                            width: 135.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(35.sp),
                                              color: const Color.fromRGBO(
                                                  150, 150, 150, 1.0),
                                            ),
                                            child: bloc.user != null
                                                    ? Image.file(
                                                        File(bloc.image!.path),
                                                        width: 135.h,
                                                        height: 135.h,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Padding(
                                                        padding:
                                                            EdgeInsets.all(43.h),
                                                        child: SvgPicture.asset(
                                                            'assets/icons/camera.svg'),
                                                      )
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
                              SvgPicture.asset('assets/icons/logo.svg'),
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.h, bottom: 10.h),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(35.sp),
                                        child: Container(
                                          alignment: Alignment.center,
                                          // padding: EdgeInsets.all(43.h),
                                          height: 135.h,
                                          width: 135.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(35.sp),
                                            color: const Color.fromRGBO(
                                                150, 150, 150, 1.0),
                                          ),
                                          child: bloc.user?.love?.photo != null
                                              ? Image.network(
                                                  apiUrl +
                                                      bloc.user!.love!.photo,
                                                  width: 135.h,
                                                  height: 135.h,
                                                  fit: BoxFit.cover,
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.all(43.h),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/camera.svg',
                                                  ),
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
                                      color:
                                          const Color.fromRGBO(23, 23, 23, 1.0),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          Container(
                            height: 70.sp,
                            margin: EdgeInsets.only(top: 44.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              alignment: Alignment.center,
                              height: 60.sp,
                              width: 0.78.sw,
                              child: TextField(
                                controller: _phoneController,
                                style: GoogleFonts.inter(
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromRGBO(210, 204, 204, 1),
                                ),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [LengthLimitingTextInputFormatter(12)],
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '+79456646786',
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromRGBO(210, 204, 204, 1),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          CustomAnimationButton(
                            text: 'Продолжить',
                            border: Border.all(
                              color: const Color.fromRGBO(32, 203, 131, 1.0),
                              width: 2.sp),
                            onPressed: () async {
                              // nextPage();
                              _inviteUser(context);
                            },
                          ),
                          SizedBox(height: 17.h),
                          CustomButton(
                            visible: bloc.user?.love != null,
                            color: redColor,
                            text: 'Отменить приглашение',
                            textColor: Colors.white,
                            onPressed: () async {
                              // nextPage();
                              BlocProvider.of<AuthBloc>(context)
                                  .add(DeleteInviteUser());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      );
    });
  }

  AppBar appBar(BuildContext context) {
    int indexPage = 3;
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
              onTap: widget.previousPage,
              child: SvgPicture.asset(
                'assets/icons/back.svg',
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
                              color: redColor,
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
