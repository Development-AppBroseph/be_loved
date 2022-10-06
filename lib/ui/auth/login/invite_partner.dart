import 'dart:async';
import 'dart:io';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/helpers/constants.dart';
import 'package:be_loved/ui/auth/login/invite_for_start_relationship.dart';
import 'package:be_loved/ui/auth/login/invite_for.dart';
import 'package:be_loved/ui/auth/login/relationships.dart';
import 'package:be_loved/widgets/buttons/custom_button.dart';
import 'package:be_loved/widgets/alerts/snack_bar.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as Get;
import 'package:google_fonts/google_fonts.dart';

class InvitePartner extends StatefulWidget {
  const InvitePartner(
      {Key? key, required this.nextPage, required this.previousPage, required this.streamController})
      : super(key: key);
  
  final streamController;
  final VoidCallback nextPage;
  final VoidCallback previousPage;

  @override
  State<InvitePartner> createState() => _InvitePartnerState();
}

class _InvitePartnerState extends State<InvitePartner> {
  late Timer _timer;

  final _phoneController = TextEditingController();

  void _inviteUser(BuildContext context) =>
      BlocProvider.of<AuthBloc>(context).add(InviteUser(_phoneController.text));

  @override
  void initState() {
    _startSearch(context);
    BlocProvider.of<AuthBloc>(context).add(DeleteInviteUser());
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
        Get.Get.to(
          RelationShips(previewPage: () {}, prevPage: () {}),
          duration: const Duration(seconds: 1),
          transition: Get.Transition.rightToLeft,
        );
        // widget.previousPage();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => RelationShips(
        //       previewPage: () {},
        //       prevPage: () {},
        //     ),
        //   ),
        // ).then((value) => _startSearch(context));
      }
      if (current is InviteError) {
        // StandartSnackBar.show(
        //   'Приглашение не удалось отправить',
        //   SnackBarStatus(Icons.error, redColor),
        // );
      }
      if (current is ReceiveInvite && previous is ReceiveInvite == false) {
        _timer.cancel();
        widget.nextPage();
        // Get.Get.to(
        //   InviteFor(
        //       previewPage: () {
        //         BlocProvider.of<AuthBloc>(context).add(DeleteInviteUser());
        //       },
        //       nextPage: () {}),
        //   duration: const Duration(seconds: 1),
        //   transition: Get.Transition.upToDown,
        // )?.then((value) => _startSearch(context));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => InviteForStartRelationship(nextPage: () {}),
        //     fullscreenDialog: true,
        //   ),
        // ).then((value) => _startSearch(context));
      }
      return true;
    }, builder: (context, state) {
      print(_phoneController.text.length == 12);
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
                                    fontWeight: FontWeight.w800,
                                    color:
                                        const Color.fromRGBO(23, 23, 23, 1.0),
                                  ),
                                ),
                                TextSpan(
                                  text: 'партнёра',
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
                            'Позови партнёра на этот экран, введи его\nномер, и ожидай принятия приглашения',
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
                                    child: Container(
                                      width: 135.h,
                                      height: 135.h,
                                      margin: EdgeInsets.only(
                                          top: 20.h, bottom: 10.h),
                                      child: GestureDetector(
                                        onTap: () {
                                          // bloc.add(EditUserInfo());
                                        },
                                        child: Material(
                                          color: const Color.fromRGBO(
                                              150, 150, 150, 1),
                                          shape: SquircleBorder(
                                            radius: BorderRadius.all(
                                              Radius.circular(80.r),
                                            ),
                                          ),
                                          clipBehavior: Clip.hardEdge,
                                          child: bloc.user != null
                                              ? bloc.user?.me.photo != null
                                                  ? Image.network(
                                                      apiUrl +
                                                          bloc.user!.me.photo,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Padding(
                                                      padding:
                                                          EdgeInsets.all(43.h),
                                                      child: SvgPicture.asset(
                                                        'assets/icons/camera.svg',
                                                      ),
                                                    )
                                              : bloc.image == null
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.all(43.h),
                                                      child: SvgPicture.asset(
                                                          'assets/icons/camera.svg'),
                                                    )
                                                  : Image.file(
                                                      File(bloc.image!.path),
                                                      width: 135.h,
                                                      height: 135.h,
                                                      fit: BoxFit.cover,
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
                                padding: EdgeInsets.all(18.w),
                                child:
                                    SvgPicture.asset('assets/icons/logo.svg'),
                              ),
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 20.h, bottom: 10.h),
                                      child: Material(
                                        color: const Color.fromRGBO(
                                            150, 150, 150, 1),
                                        shape: SquircleBorder(
                                          radius: BorderRadius.all(
                                            Radius.circular(80.r),
                                          ),
                                        ),
                                        clipBehavior: Clip.hardEdge,
                                        child: bloc.user?.love?.photo != null && bloc.state is InviteAccepted
                                            ? Image.network(
                                                apiUrl + bloc.user!.love!.photo,
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
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(12),
                                  // CustomInputFormatter()
                                ],
                                onChanged: (text) {
                                  if (text.length == 1 && text != '+') {
                                    // setState(() {
                                    _phoneController.text = '+7$text';
                                    _phoneController.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                        offset: _phoneController.text.length,
                                      ),
                                    );
                                    // });
                                  }
                                  if (text.length == 12) {
                                    bloc.add(TextFieldFilled(true));
                                  } else {
                                    bloc.add(TextFieldFilled(false));
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: '+79990009900',
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 25.sp,
                                    color:
                                        const Color.fromRGBO(150, 150, 150, 1),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  border: InputBorder.none,
                                  alignLabelWithHint: true,
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
                          CustomButton(
                            color: const Color.fromRGBO(32, 203, 131, 1.0),
                            text: 'Продолжить',
                            validate: _phoneController.text.length == 12,
                            code: false,
                            textColor: Colors.white,
                            onPressed: () => _inviteUser(context),
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
                          CustomButton(
                            visible:
                                bloc.user?.love != null && bloc.user!.fromYou!,
                            color: redColor,
                            text: 'Отменить приглашение',
                            textColor: Colors.white,
                            validate: true,
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
      toolbarHeight: 100,
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
      title: Padding(
        padding: EdgeInsets.only(top: 20.h, right: 6.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                padding: const EdgeInsets.only(right: 20),
                icon: SvgPicture.asset(
                  'assets/icons/back.svg',
                  width: 15,
                ),
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: widget.previousPage,
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
