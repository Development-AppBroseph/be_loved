import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/widgets/texts/important_text_widget.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class UserTag extends StatelessWidget {
  final EventEntity eventEntity;
  final bool isSelected;
  final Function(bool s) onSelect;
  UserTag({Key? key, required this.eventEntity, required this.onSelect, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelect(!isSelected);
      },
      behavior: HitTestBehavior.translucent,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eventEntity.title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: ClrStyle.black17ToWhite[sl<AuthConfig>().idx],
                ),
              ),
              eventEntity.important
              ? ImportantTextWidget()
              : Text(
                'Добавил(а): ${eventEntity.eventCreator.username}',
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
                value: isSelected,
                splashRadius: 0,
                activeColor: const Color(0xffFF1D1D),
                side: MaterialStateBorderSide.resolveWith(
                  (states) => const BorderSide(
                    width: 3,
                    color: Color(0xffFF1D1D),
                  ),
                ),
                onChanged: (value) {
                  onSelect(value!);
                }),
          )
        ],
      ),
    );
  }
}
