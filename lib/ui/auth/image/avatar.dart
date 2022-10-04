import 'dart:async';
import 'dart:io';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/helpers/constants.dart';
import 'package:be_loved/widgets/buttons/custom_animation_button.dart';
import 'package:be_loved/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPage extends StatelessWidget {
  AvatarPage({Key? key, required this.nextPage, required this.previousPage})
      : super(key: key);

  final VoidCallback nextPage;
  XFile? xFile;
  final VoidCallback previousPage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
      if (current is ImageSuccess) {
        xFile = current.image;
        return true;
      }
      if (current is InitSuccess) {
        nextPage();
      }
      if (current is InitError) {}
      return true;
    }, builder: (context, state) {
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
                            text: 'Поставь ',
                            style: GoogleFonts.inter(
                              fontSize: 35.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(23, 23, 23, 1.0),
                            ),
                          ),
                          TextSpan(
                            text: 'аватарку',
                            style: GoogleFonts.inter(
                              fontSize: 35.sp,
                              fontWeight: FontWeight.bold,
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
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.sp, bottom: 36.sp),
                        child: GestureDetector(
                          onTap: () async {
                            bloc.add(PickImage());
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35.sp),
                            child: Container(
                              alignment: Alignment.center,
                              height: 135.h,
                              width: 135.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35.sp),
                                color: const Color.fromRGBO(150, 150, 150, 1.0),
                              ),
                              child: xFile != null
                                  ? Image.file(
                                      File(xFile!.path),
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
                    ),
                    AspectRatio(
                      aspectRatio: 330/267,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(228, 228, 228, 1.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AvatarMenu(),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    if (state is AuthLoading == false)
                      CustomAnimationButton(
                        text: 'Продолжить',
                        border: Border.all(
                          color: const Color.fromRGBO(32, 203, 131, 1.0),
                          width: 2.sp),
                        onPressed: () async {
                          bloc.add(InitUser());
                        },
                      ),
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
      toolbarHeight: 80.sp,
      backgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
      title: Padding(
        padding: EdgeInsets.only(left: 20.sp, top: 40.sp, right: 6.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: previousPage,
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

class AvatarMenu extends StatelessWidget {
  AvatarMenu({Key? key}) : super(key: key);

  final streamController = StreamController<int>();
  final pageController = PageController(viewportFraction: 1.0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: PageView(
          controller: pageController,
          onPageChanged: (value) {
            streamController.add(value);
          },
          children: const [
            PageTest(),
            PageTest(),
            PageTest(),
            PageTest(),
          ],
        )),
        Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(216, 216, 216, 1.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.sp),
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
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/icons/men.svg',
                        color: page.data == 0 ? Colors.black : Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/women.svg',
                        color: page.data == 1 ? Colors.black : Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pageController.animateToPage(
                          2,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: SvgPicture.asset(
                        'assets/icons/paw.svg',
                        color: page.data == 2 ? Colors.black : Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        pageController.animateToPage(
                            3,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/rects.svg',
                        color: page.data == 3 ? Colors.black : Colors.grey,
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

class PageTest extends StatelessWidget {
  const PageTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 12,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, mainAxisSpacing: 15, crossAxisSpacing: 20),
          itemBuilder: ((context, index) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(150, 150, 150, 1),
                  borderRadius: BorderRadius.circular(22)),
            );
          })),
    );
  }
}
