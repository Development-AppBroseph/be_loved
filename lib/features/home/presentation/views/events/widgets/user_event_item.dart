import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/helpers/date_time_helper.dart';
import 'package:be_loved/core/utils/helpers/truncate_text_helper.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/texts/important_text_widget.dart';
import 'package:be_loved/features/home/domain/entities/events/event_entity.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/all_events.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class UserEventItem extends StatelessWidget {
  final EditorState editorState;
  final EventEntity eventEntity;
  final bool isSelected;
  final Function() onTapDelete;
  final Function(bool val) onSelect;
  final Function() onLongPress;
  final Function() onTap;

  UserEventItem({
    required this.editorState, 
    required this.isSelected,
    required this.onLongPress,
    required this.onTap,
    required this.onTapDelete,
    required this.onSelect,
    required this.eventEntity
  });

  ScrollController scrollController = ScrollController();

  void scrollToBottom() {
    if(editorState == EditorState.just){
      scrollController.animateTo(0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        height: 44.h,
        child: ListView(
          reverse: true,
          controller: scrollController,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          scrollDirection: Axis.horizontal,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: editorState != EditorState.oneItemDelete ? 378.w : 311.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        truncateWithEllipsis(22, eventEntity.title),
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
                  editorState == EditorState.groupSelect
                    ? GestureDetector(
                      onTap: (){
                        onSelect(!isSelected);
                      },
                      child: SvgPicture.asset(
                        isSelected
                        ? 'assets/icons/checked_event.svg' 
                        : 'assets/icons/unchecked_event.svg', 
                      ),
                    )
                    : Align(
                        alignment: Alignment.center,
                        child: Text(
                          getTextFromDate(eventEntity.datetimeString, null, editorState != EditorState.just),
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: getColorFromDays(eventEntity.datetimeString, eventEntity.important),
                          ),
                        ),
                      ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onTapDelete,
              child: Padding(
                padding: EdgeInsets.only(right: 32.w),
                child: SvgPicture.asset(
                  SvgImg.minus,
                  height: 24.h,
                  width: 24.w,
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}