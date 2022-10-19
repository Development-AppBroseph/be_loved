import 'dart:async';
import 'dart:io';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/models/helpers/small_image.dart';
import 'package:be_loved/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';

class AvatarPage extends StatelessWidget {
  AvatarPage({Key? key, required this.nextPage, required this.previousPage})
      : super(key: key);

  final VoidCallback nextPage;
  XFile? xFile;
  String? error;
  final VoidCallback previousPage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
      if (current is ImageSuccess) {
        error = null;
        xFile = current.image;
        return true;
      }
      if (current is InitSuccess) {
        error = null;
        nextPage();
      }
      if (current is InitError) error = current.error;
      return true;
    }, builder: (context, state) {
      var bloc = BlocProvider.of<AuthBloc>(context);
      return Scaffold(
        appBar: appBar(context),
        backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
        body: SafeArea(
            bottom: true,
            child: Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 10),
              child: SingleChildScrollView(
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
                            text: 'Поставь ',
                            style: GoogleFonts.inter(
                              fontSize: 35.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color.fromRGBO(23, 23, 23, 1.0),
                            ),
                          ),
                          TextSpan(
                            text: 'аватарку',
                            style: GoogleFonts.inter(
                              fontSize: 35.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color.fromRGBO(255, 29, 29, 1.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Выбери из предложенных вариантов, или\nпоставь свою ',
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        color: const Color.fromRGBO(137, 137, 137, 1.0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(top: 15.h, bottom: 30.h),
                        width: 135.h,
                        height: 135.h,
                        child: GestureDetector(
                          onTap: () async {
                            bloc.add(PickImage());
                          },
                          child: Material(
                            color: const Color.fromRGBO(150, 150, 150, 1),
                            shape: SquircleBorder(
                              radius: BorderRadius.all(
                                Radius.circular(80.r),
                              ),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: xFile != null
                                ? Image.file(
                                    File(xFile!.path),
                                    width: 135,
                                    height: 135,
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
                    Container(
                      clipBehavior: Clip.hardEdge,
                      width: 378.w,
                      height: 307.w,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(228, 228, 228, 1.0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AvatarMenu(),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    if (state is AuthLoading == false)
                      CustomButton(
                        color: const Color.fromRGBO(32, 203, 131, 1.0),
                        text: bloc.image != null ? 'Продолжить' : 'Пропустить',
                        validate: true,
                        textColor: Colors.white,
                        onPressed: () => bloc.add(
                          InitUser(),
                        ),
                      ),
                    // CustomAnimationButton(
                    //   text: 'Продолжить',
                    //   border: Border.all(
                    //     color: const Color.fromRGBO(32, 203, 131, 1.0),
                    //     width: 2.sp),
                    //   onPressed: () async {
                    //     bloc.add(InitUser());
                    //   },
                    // ),
                  ],
                ),
              ),
            )),
      );
    });
  }

  AppBar appBar(BuildContext context) {
    int indexPage = 2;
    return AppBar(
      elevation: 0,
      toolbarHeight: 80,
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
      title: Padding(
        padding: EdgeInsets.only(top: 20.h, right: 6.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 55.h,
              width: 55.w,
              alignment: Alignment.bottomCenter,
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

class AvatarMenu extends StatelessWidget {
  AvatarMenu({Key? key}) : super(key: key);

  final streamController = StreamController<int>();
  final pageController = PageController(viewportFraction: 1.0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 262.w,
          child: PageView(
            controller: pageController,
            onPageChanged: (value) {
              streamController.add(value);
            },
            children: [
              PageTest(),
              PageTest(),
              PageTest(),
              PageTest(),
            ],
          ),
        ),
        Container(
          height: 45.w,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(216, 216, 216, 1.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.sp),
            child: StreamBuilder<int>(
              initialData: 0,
              stream: streamController.stream,
              builder: (context, page) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/men.svg',
                            height: 17,
                            width: 17,
                            color: Colors.grey,
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: page.data == 0 ? 1 : 0,
                            child: SvgPicture.asset(
                              'assets/icons/men.svg',
                              height: 17,
                              width: 17,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pageController.animateToPage(1,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut);
                      },
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/women.svg',
                            height: 17,
                            width: 17,
                            color: Colors.grey,
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: page.data == 1 ? 1 : 0,
                            child: SvgPicture.asset(
                              'assets/icons/women.svg',
                              height: 17,
                              width: 17,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pageController.animateToPage(
                          2,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/paw.svg',
                            height: 17,
                            width: 17,
                            color: Colors.grey,
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: page.data == 2 ? 1 : 0,
                            child: SvgPicture.asset(
                              'assets/icons/paw.svg',
                              height: 17,
                              width: 17,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pageController.animateToPage(3,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut);
                      },
                      child: Stack(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/rects.svg',
                            height: 17,
                            width: 17,
                            color: Colors.grey,
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: page.data == 3 ? 1 : 0,
                            child: SvgPicture.asset(
                              'assets/icons/rects.svg',
                              height: 17,
                              width: 17,
                              color: Colors.black,
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
        )
      ],
    );
  }
}

class PageTest extends StatefulWidget {
  PageTest({Key? key}) : super(key: key);

  @override
  State<PageTest> createState() => _PageTestState();
}

class _PageTestState extends State<PageTest> {
  List<SmallImage> _images = [
    SmallImage('', false),
    SmallImage('', false),
    SmallImage('', false),
    SmallImage('', false),
    SmallImage('', false),
    SmallImage('', false),
    SmallImage('', false),
    SmallImage('', false),
    SmallImage('', false),
    SmallImage('', false),
    SmallImage('', false),
    SmallImage('', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 267.h,
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _images.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisSpacing: 15.w, crossAxisSpacing: 20.w),
          itemBuilder: ((context, index) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 67.w,
                    width: 67.w,
                    child: GestureDetector(
                      onTap: () {
                        _images.forEach((element) {
                          element.selected = false;
                        });
                        _images[index].selected = true;
                        setState(() {});
                      },
                      child: CupertinoCard(
                        child: Container(
                          color: Colors.grey,
                        ),
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        color: Colors.white,
                        radius: BorderRadius.all(Radius.circular(40.r)),
                      ),
                    ),
                  ),
                ),
                if (_images[index].selected)
                  Align(
                    alignment: Alignment.topRight,
                    child: SvgPicture.asset(
                      'assets/icons/check.svg',
                      width: 20.w,
                      height: 20.h,
                    ),
                  )
              ],
            );
            // return Container(
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //       color: const Color.fromRGBO(150, 150, 150, 1),
            //       borderRadius: BorderRadius.circular(23.r)),
            // );
          })),
    );
  }
}
