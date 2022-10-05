import 'dart:async';
import 'dart:io';

import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/helpers/constants.dart';
import 'package:be_loved/ui/home/home.dart';
import 'package:be_loved/widgets/buttons/custom_button.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class RelationShips extends StatelessWidget {
  RelationShips({Key? key, required this.previewPage, required this.prevPage})
      : super(key: key);

  final VoidCallback previewPage;
  final VoidCallback prevPage;
  final _streamController = StreamController<DateTime>();

  String date = '';

  void _relationShips(BuildContext context) {
    if (date != '') {
      BlocProvider.of<AuthBloc>(context).add(StartRelationships(date));
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
      if (current is ReletionshipsStarted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
        return true;
      }
      return true;
    }, builder: (context, snapshot) {
      var bloc = BlocProvider.of<AuthBloc>(context);
      return Scaffold(
        appBar: appBar(context),
        backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
        body: SafeArea(
            bottom: true,
            child: Padding(
              padding: EdgeInsets.only(left: 24.sp, right: 24.sp, top: 0.1.sw),
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
                            text: 'Когда начались\n',
                            style: GoogleFonts.inter(
                              fontSize: 35.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color.fromRGBO(23, 23, 23, 1.0),
                            ),
                          ),
                          TextSpan(
                            text: 'ваши ',
                            style: GoogleFonts.inter(
                              fontSize: 35.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color.fromRGBO(23, 23, 23, 1.0),
                            ),
                          ),
                          TextSpan(
                            text: 'отношения?',
                            style: GoogleFonts.inter(
                              fontSize: 35.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color.fromRGBO(255, 29, 29, 1.0),
                            ),
                          ),
                        ],
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
                                padding:
                                    EdgeInsets.only(top: 20.h, bottom: 10.h),
                                child: Material(
                                  color: const Color.fromRGBO(150, 150, 150, 1),
                                  shape: SquircleBorder(
                                    radius: BorderRadius.all(
                                      Radius.circular(80.r),
                                    ),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: bloc.user == null
                                      ? bloc.image != null
                                          ? Image.file(
                                              File(bloc.image!.path),
                                              width: 135.h,
                                              height: 135.h,
                                              fit: BoxFit.cover,
                                            )
                                          : Padding(
                                              padding: EdgeInsets.all(43.h),
                                              child: SvgPicture.asset(
                                                  'assets/icons/camera.svg'),
                                            )
                                      : bloc.user?.me.photo != null
                                          ? Image.network(
                                              apiUrl + bloc.user!.me.photo,
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
                              bloc.user != null
                                  ? bloc.user!.me.username
                                  : bloc.nickname.toString(),
                              style: GoogleFonts.inter(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromRGBO(23, 23, 23, 1.0),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(18.w),
                          child: SvgPicture.asset('assets/icons/logov2.svg'),
                        ),
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(top: 20.h, bottom: 10.h),
                                child: Material(
                                  color: const Color.fromRGBO(150, 150, 150, 1),
                                  shape: SquircleBorder(
                                    radius: BorderRadius.all(
                                      Radius.circular(80.r),
                                    ),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: bloc.user?.love?.photo != null
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
                                color: const Color.fromRGBO(23, 23, 23, 1.0),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    StreamBuilder<DateTime>(
                        stream: _streamController.stream,
                        initialData: DateTime.now(),
                        builder: (context, snapshot) {
                          return SizedBox(
                            height: 206.h,
                            child: ScrollDatePicker(
                              maximumDate: DateTime.now(),
                              locale: const Locale('ru', 'RU'),
                              onDateTimeChanged: (DateTime value) {
                                bloc.add(TextFieldFilled(true));
                                date = value.toString().substring(0, 10);
                                _streamController.sink.add(value);
                              },
                              selectedDate: snapshot.data!,
                            ),
                          );
                        }),
                    CustomButton(
                      color: accentColor,
                      text: 'Готово',
                      textColor: Colors.white,
                      onPressed: () => _relationShips(context),
                    ),
                  ],
                ),
              ),
            )),
      );
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
