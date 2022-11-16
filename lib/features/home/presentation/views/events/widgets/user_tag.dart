import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserTag extends StatefulWidget {
  const UserTag({Key? key}) : super(key: key);

  @override
  State<UserTag> createState() => _UserTagState();
}

class _UserTagState extends State<UserTag> {
  bool isPointed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isPointed) {
            isPointed = false;
          } else {
            isPointed = true;
          }
        });
      },
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
          SizedBox(
            height: 25.h,
            width: 25.w,
            child: Checkbox(
                shape: const CircleBorder(),
                value: isPointed,
                splashRadius: 0,
                activeColor: const Color(0xffFF1D1D),
                side: MaterialStateBorderSide.resolveWith(
                  (states) => const BorderSide(
                    width: 3,
                    color: Color(0xffFF1D1D),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    isPointed = value!;
                  });
                }),
          )
        ],
      ),
    );
  }
}
