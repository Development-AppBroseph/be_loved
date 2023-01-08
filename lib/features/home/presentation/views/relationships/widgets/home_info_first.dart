import 'dart:async';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomeInfoFirst extends StatefulWidget {
  final Function() onRelationTap;
  HomeInfoFirst({required this.onRelationTap});
  @override
  State<HomeInfoFirst> createState() => _HomeInfoFirstState();
}

class _HomeInfoFirstState extends State<HomeInfoFirst> {
  int days = 0;
  int hour = 0;
  int minute = 0;
  Timer? _timer;

  final streamController = StreamController<bool>();

  @override
  void initState() {
    super.initState();
    if (sl<AuthConfig>().user != null) {
      startTimer();
    }
  }

  @override
  void dispose() {
    streamController.close();
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    var oneSec = const Duration(seconds: 1);
    setTime();
    // Timer.periodic(const Duration(seconds: 60), (Timer timer) {
    //   setTime();
    // });
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (DateTime.now().second == 0) {
          _timer!.cancel();
          Timer.periodic(const Duration(seconds: 5), (Timer timer) {
            setTime();
          });
        }
        setTime();
      },
    );
  }

  void setTime() async {
    UserAnswer? user = sl<AuthConfig>().user;
    print('SET TIME: ${sl<AuthConfig>().token} : ${sl<AuthConfig>().user?.date}');
    if (user!.date != null) {
      final startTime = user.date as String;
      final array = startTime.split('-');

      DateTime berlinWallFell = DateTime.now();
      DateTime moonLanding = DateTime(
          int.parse(array[0]), int.parse(array[1]), int.parse(array[2].substring(0, 2)));

      final difference = berlinWallFell.difference(moonLanding);

      days = difference.inDays;
      hour = difference.inHours - difference.inDays * 24;
      minute = difference.inMinutes - difference.inHours * 60;

      // streamController. add(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      // padding: EdgeInsets.only(top: 11.h, left: 20.w, right: 25.w),
      // decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(20.r), color: Colors.white),
      child: CupertinoCard(
        radius: BorderRadius.circular(40.r),
        color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
        elevation: 0,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.only(top: 11.h, left: 20.w, right: 25.w),
        child: StreamBuilder<bool>(
            stream: streamController.stream,
            builder: (context, snapshot) {
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Вы встречаетесь уже:',
                            style: TextStyle(
                                color: const Color(0xFF969696),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 9.h,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: widget.onRelationTap,
                        behavior: HitTestBehavior.translucent,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5.h),
                          child: SvgPicture.asset(
                            SvgImg.settings,
                            height: 18.67.h,
                            width: 18.67.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$days',
                        style: TextStyle(
                            color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                            fontSize: 50.sp,
                            fontWeight: FontWeight.w700),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 7.h),
                        child: Text(
                          'д',
                          style: TextStyle(
                              color: const Color(0xFF969696),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        '$hour',
                        style: TextStyle(
                            color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                            fontSize: 50.sp,
                            fontWeight: FontWeight.w700),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 7.h),
                        child: Text(
                          'ч',
                          style: TextStyle(
                              color: const Color(0xFF969696),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        '$minute',
                        style: TextStyle(
                            color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                            fontSize: 50.sp,
                            fontWeight: FontWeight.w700),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 7.h),
                        child: Text(
                          'мин',
                          style: TextStyle(
                              color: const Color(0xFF969696),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  )
                ],
              );
            }),
      ),
    );
  }
}
