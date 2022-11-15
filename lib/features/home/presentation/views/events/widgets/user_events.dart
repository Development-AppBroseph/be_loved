import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserEvents extends StatelessWidget {
  final int countPage;
  const UserEvents({Key? key, required this.countPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
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
