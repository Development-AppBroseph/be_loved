import 'dart:async';
import 'package:be_loved/constants/constants.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/home_info_first/controller/home_info_first_cubit.dart';
import 'package:be_loved/features/home/presentation/views/relationships/widgets/home_info_first/controller/home_info_first_state.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  int years = 0;
  int month = 0;
  int daysInYears = 0;

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
    print(
        'SET TIME: ${sl<AuthConfig>().token} : ${sl<AuthConfig>().user?.date}');
    if (user!.date != null) {
      final startTime = user.date as String;
      final array = startTime.split('-');

      DateTime berlinWallFell = DateTime.now();
      DateTime moonLanding = DateTime(
        int.parse(array[0]),
        int.parse(array[1]),
        int.parse(
          array[2].substring(0, 2),
        ),
      );

      final difference = berlinWallFell.difference(moonLanding);
      years = difference.inDays ~/ 365;
      month = (difference.inDays % 365) ~/ 30;
      daysInYears = (difference.inDays % 365) - Months.returnDays(month);
      days = difference.inDays;
      hour = difference.inHours - difference.inDays * 24;
      minute = difference.inMinutes - difference.inHours * 60;
      context.read<HomeInfoFirstCubit>().getTime(
            days,
            hour,
            minute,
            years,
            month,
            daysInYears,
          );
      streamController.add(true);
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
        decoration:
            BoxDecoration(color: ClrStyle.whiteTo17[sl<AuthConfig>().idx]),
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
                  BlocBuilder<HomeInfoFirstCubit, HomeInfoFirstState>(
                    builder: (context, state) {
                      if (state is HomeInfoFirstOnlyMinutesState) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${state.minutes}',
                              style: TextStyle(
                                  color: ClrStyle
                                      .black17ToWhite[sl<AuthConfig>().idx],
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
                        );
                      } else if (state
                          is HomeInfoFirstOnlyHoursAndMinutesState) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${state.hours}',
                              style: TextStyle(
                                  color: ClrStyle
                                      .black17ToWhite[sl<AuthConfig>().idx],
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
                              '${state.minutes}',
                              style: TextStyle(
                                  color: ClrStyle
                                      .black17ToWhite[sl<AuthConfig>().idx],
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
                        );
                      } else if (state
                          is HomeInfoFirstOnlyDayHoursAndMinutesState) {
                            return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${state.days}',
                            style: TextStyle(
                                color: ClrStyle
                                    .black17ToWhite[sl<AuthConfig>().idx],
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
                            '${state.hours}',
                            style: TextStyle(
                                color: ClrStyle
                                    .black17ToWhite[sl<AuthConfig>().idx],
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
                            '${state.minutes}',
                            style: TextStyle(
                                color: ClrStyle
                                    .black17ToWhite[sl<AuthConfig>().idx],
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
                      );
                      } else if (state is HomeInfoFirstMonthDaysAndHours) {
                        return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${state.month}',
                            style: TextStyle(
                                color: ClrStyle
                                    .black17ToWhite[sl<AuthConfig>().idx],
                                fontSize: 50.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 7.h),
                            child: Text(
                              'мес',
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
                            '${state.days}',
                            style: TextStyle(
                                color: ClrStyle
                                    .black17ToWhite[sl<AuthConfig>().idx],
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
                            '${state.hours}',
                            style: TextStyle(
                                color: ClrStyle
                                    .black17ToWhite[sl<AuthConfig>().idx],
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
                        ],
                      );
                      } else if (state
                          is HomeInfoFirstMonthDaysHoursAndMinutes) {
                            return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${state.month}',
                            style: TextStyle(
                                color: ClrStyle
                                    .black17ToWhite[sl<AuthConfig>().idx],
                                fontSize: 50.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 7.h),
                            child: Text(
                              'мес',
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
                            '${state.days}',
                            style: TextStyle(
                                color: ClrStyle
                                    .black17ToWhite[sl<AuthConfig>().idx],
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
                            '${state.hours}',
                            style: TextStyle(
                                color: ClrStyle
                                    .black17ToWhite[sl<AuthConfig>().idx],
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
                            '${state.minutes}',
                            style: TextStyle(
                                color: ClrStyle
                                    .black17ToWhite[sl<AuthConfig>().idx],
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
                      );
                      } else if (state is HomeInfoFirstYearsMonthsAndDays) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${state.years}',
                              style: TextStyle(
                                  color: ClrStyle
                                      .black17ToWhite[sl<AuthConfig>().idx],
                                  fontSize: 50.sp,
                                  fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 7.h),
                              child: Text(
                                'г',
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
                              '${state.months}',
                              style: TextStyle(
                                  color: ClrStyle
                                      .black17ToWhite[sl<AuthConfig>().idx],
                                  fontSize: 50.sp,
                                  fontWeight: FontWeight.w700),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 7.h),
                              child: Text(
                                'мес',
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
                              '${state.days}',
                              style: TextStyle(
                                  color: ClrStyle
                                      .black17ToWhite[sl<AuthConfig>().idx],
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
                          ],
                        );
                      }
                      return Container();
                    },
                  )
                ],
              );
            }),
      ),
    );
  }
}