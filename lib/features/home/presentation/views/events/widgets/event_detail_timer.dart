import 'dart:async';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/auth/data/models/auth/user.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class EventDetailTimer extends StatefulWidget {
  final EventEntity eventEntity;
  EventDetailTimer({required this.eventEntity});
  @override
  State<EventDetailTimer> createState() => _EventDetailTimerState();
}

class _EventDetailTimerState extends State<EventDetailTimer> {
  int days = 0;
  int hour = 0;
  int minute = 0;
  Timer? _timer;

  final streamController = StreamController<bool>();

  @override
  void initState() {
    super.initState();
    startTimer();
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
    print('DATE s: ${widget.eventEntity.start}');
    DateTime berlinWallFell = DateTime.now();
    DateTime fromDays = DateTime.now().add(Duration(days: int.parse(widget.eventEntity.datetimeString)));
    DateTime moonLanding = DateTime(fromDays.year, fromDays.month, fromDays.day, widget.eventEntity.start.hour, widget.eventEntity.start.minute);

    final difference = moonLanding.difference(berlinWallFell);

    days = difference.inDays;
    hour = difference.inHours - difference.inDays * 24;
    minute = difference.inMinutes - difference.inHours * 60;

    if(days.isNegative){
      days = 0;
    }
    if(hour.isNegative){
      hour = 0;
    }
    if(minute.isNegative){
      minute = 0;
    }
    streamController. add(true);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
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
                            'До события осталось:',
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
