import 'dart:async';
import 'dart:io';
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/bloc/common_socket/web_socket_bloc.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/helpers/small_image.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/auth/data/models/auth/select_image.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
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
        BlocProvider.of<WebSocketBloc>(context)
            .add(WebSocketEvent(current.token));
        nextPage();
      }
      if (current is InitError) error = current.error;
      return true;
    }, builder: (context, state) {
      var bloc = BlocProvider.of<AuthBloc>(context);
      return Scaffold(
        appBar: appBar(context),
        backgroundColor: sl<AuthConfig>().idx == 1 ? ColorStyles.blackColor : const Color.fromRGBO(240, 240, 240, 1.0),
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
                              color: ClrStyle.black2CToWhite[sl<AuthConfig>().idx],
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(40.r),
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
                                      SvgImg.camera,
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
      backgroundColor: sl<AuthConfig>().idx == 1 ? ColorStyles.blackColor : const Color.fromRGBO(240, 240, 240, 1.0),
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

class AvatarMenu extends StatefulWidget {
  const AvatarMenu({Key? key}) : super(key: key);

  @override
  State<AvatarMenu> createState() => _AvatarMenuState();
}

class _AvatarMenuState extends State<AvatarMenu> {
  final streamController = StreamController<int>();

  final pageController = PageController(viewportFraction: 1.0, keepPage: false);

  SelectImage selectImage = SelectImage();

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
              setState(() {});
            },
            children: [
              PageTest(page: 0, selectImage: selectImage),
              PageTest(page: 1, selectImage: selectImage),
              PageTest(page: 2, selectImage: selectImage),
              PageTest(page: 3, selectImage: selectImage),
            ],
          ),
        ),
        Container(
          height: 45.w,
          decoration: BoxDecoration(
            color: ClrStyle.greyD8ToBlack2C[sl<AuthConfig>().idx],
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
                            curve: Curves.easeInOutQuint,
                            duration: const Duration(milliseconds: 300),
                            opacity: page.data == 0 ? 1 : 0,
                            child: SvgPicture.asset(
                              'assets/icons/men.svg',
                              height: 17,
                              width: 17,
                              color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
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
                            curve: Curves.easeInOutQuint,
                            duration: const Duration(milliseconds: 300),
                            opacity: page.data == 1 ? 1 : 0,
                            child: SvgPicture.asset(
                              'assets/icons/women.svg',
                              height: 17,
                              width: 17,
                              color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
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
                            SvgImg.paw,
                            height: 17,
                            width: 17,
                            color: Colors.grey,
                          ),
                          AnimatedOpacity(
                            curve: Curves.easeInOutQuint,
                            duration: const Duration(milliseconds: 300),
                            opacity: page.data == 2 ? 1 : 0,
                            child: SvgPicture.asset(
                              SvgImg.paw,
                              height: 17,
                              width: 17,
                              color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
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
                            SvgImg.rects,
                            height: 17,
                            width: 17,
                            color: Colors.grey,
                          ),
                          AnimatedOpacity(
                            curve: Curves.easeInOutQuint,
                            duration: const Duration(milliseconds: 300),
                            opacity: page.data == 3 ? 1 : 0,
                            child: SvgPicture.asset(
                              SvgImg.rects,
                              height: 17,
                              width: 17,
                              color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx]
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
  SelectImage selectImage;
  int page;
  PageTest({
    Key? key,
    required this.page,
    required this.selectImage,
  }) : super(key: key);

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
    print('object ${widget.selectImage.page}|||${widget.selectImage.image}');
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
                        widget.selectImage.image = index;
                        widget.selectImage.page = widget.page;
                        // _images.forEach((element) {
                        //   element.selected = false;
                        // });
                        // _images[index].selected = true;
                        setState(() {});
                      },
                      child: CupertinoCard(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        color: Colors.white,
                        radius: BorderRadius.all(Radius.circular(40.r)),
                        child: Container(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.selectImage.page == widget.page &&
                    widget.selectImage.image == index)
                  Align(
                    alignment: Alignment.topRight,
                    child: SvgPicture.asset(
                      SvgImg.check,
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
