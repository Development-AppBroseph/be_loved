import 'package:be_loved/core/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyCard extends StatelessWidget {
  final bool isAvailable;
  final bool isModal;
  final bool inHistory;
  const EmptyCard(
      {Key? key,
      this.isAvailable = false,
      this.isModal = false,
      this.inHistory = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          Img.sad,
          width: 120.w,
          height: 80.h,
        ),
        SizedBox(
          height: 50.h,
        ),
        Text(
          isAvailable
              ? 'Доступных целей нет :('
              : inHistory
                  ? 'Вы не достигли ни одной цели :('
                  : 'Целей нет :(',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff969696),
          ),
        ),
      ],
    );
  }
}
