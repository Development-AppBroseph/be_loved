import 'dart:async';
import 'package:be_loved/ui/auth/invitePartner.dart';
import 'package:be_loved/ui/auth/name.dart';
import 'package:be_loved/ui/auth/avatar.dart';
import 'package:be_loved/ui/auth/relationships.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreateAccountInfo extends StatelessWidget {
  CreateAccountInfo({Key? key}) : super(key: key);
  
  final streamController = StreamController<int>();
  final pageController = PageController(viewportFraction: 1.0, keepPage: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SafeArea(
        bottom: true,
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: (value) => streamController.add(value + 1),
          children: [
            InputNamePage(onTap: nextPage),
            AvatarPage(onTap: nextPage),
            InvitePartner(onTap: nextPage),
            const RelationShips()
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
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
              onTap: () => pageController.page != 0.0 
                ? pageController.previousPage(duration: const Duration(milliseconds: 100), curve: Curves.easeInOut) 
                : Navigator.pop(context),
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                width: 15.sp,
              ),
            ),
            StreamBuilder<int>(
              initialData: 1,
              stream: streamController.stream,
              builder: (context, page) {
                return SizedBox(
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
                          color: page.data! == index
                              ? Colors.blue
                              : page.data! > index
                                  ? Colors.black
                                  : Colors.white,
                          border: page.data! + 1 > index
                              ? null
                              : Border.all(
                                  width: 1,
                                  color: const Color.fromRGBO(255, 29, 29, 1.0),
                                ),
                        ),
                      );
                    },
                  ),
                );
              }
            )
          ],
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  void nextPage() {
    pageController.nextPage(duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
  }
}
