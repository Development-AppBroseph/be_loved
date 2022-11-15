import 'package:be_loved/core/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserEvents extends StatefulWidget {
  final int countPage;
  const UserEvents({Key? key, required this.countPage}) : super(key: key);

  @override
  State<UserEvents> createState() => _UserEventsState();
}

class _UserEventsState extends State<UserEvents> {
  final ScrollController scrollController = ScrollController();
  void scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          AnimatedContainer(
            height: 44.h,
            width: widget.countPage == 1 ? 250.w : 200.w,
            duration: const Duration(milliseconds: 600),
            child: SingleChildScrollView(
                reverse: false,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                controller: scrollController,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 32.w),
                      child: SvgPicture.asset(
                        SvgImg.minus,
                        height: 24.h,
                        width: 24.w,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Арбузный вечер',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff171717),
                          ),
                        ),
                        Text(
                          'Добавил(а): Никита Белых',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff969696),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Через 6 дней',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xff1D33FF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
