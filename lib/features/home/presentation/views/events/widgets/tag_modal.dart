import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/core/widgets/text_fields/default_text_form_field.dart';
import 'package:be_loved/features/home/data/models/home/hashTag.dart';
import 'package:be_loved/features/home/presentation/views/events/widgets/user_tag.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/create_event_widget.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../relationships/modals/icon_select_modal.dart';
import 'color_select.dart';

class TagModal extends StatefulWidget {
  final TypeHashTag typeHashTag;
  const TagModal({Key? key, required this.typeHashTag}) : super(key: key);

  @override
  State<TagModal> createState() => _TagModalState();
}

class _TagModalState extends State<TagModal> {
  bool isPointed = false;
  ScrollController scrollController = ScrollController();
  int iconIndex = 15;
  GlobalKey iconBtn = GlobalKey();
  showColorModal() async {
    await scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutQuint);
    colorSelectModal(
      context,
      getWidgetPosition(iconBtn),
      (index) {
        setState(() {
          iconIndex = index;
        });
        Navigator.pop(context);
      },
      iconIndex,
    );
  }

  final TextEditingController titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CupertinoCard(
      radius: BorderRadius.vertical(
        top: Radius.circular(80.r),
      ),
      elevation: 0,
      margin: EdgeInsets.zero,
      child: SizedBox(
        height: 750.h,
        child: SingleChildScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Column(
            children: [
              Container(
                height: 5.h,
                width: 100.w,
                margin: EdgeInsets.only(top: 7.h, bottom: 10.h),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: const Color(0xff969696)),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 38.h),
                child: Text(
                  widget.typeHashTag == TypeHashTag.add
                      ? "Создать тег"
                      : "Редактировать тег",
                  style: TextStyle(
                    fontFamily: "Inter",
                    color: const Color(0xff969696),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DefaultTextFormField(
                hint: 'Название',
                maxLines: 1,
                controller: titleController,
                maxLength: 40,
                hideCounter: true,
              ),
              Container(
                height: 57.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: ColorStyles.backgroundColorGrey),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                margin: EdgeInsets.only(top: 18.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Цвет',
                      style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 18.sp,
                          color: const Color(0xff2C2C2E),
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: showColorModal,
                        onPanEnd: (d) {
                          showColorModal();
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          children: [
                            iconIndex == 3
                                ? SvgPicture.asset(
                                    'assets/icons/no_icon.svg',
                                    height: 28.h,
                                    key: iconBtn,
                                  )
                                : SvgPicture.asset(SvgImg.colors[1], key: iconBtn,),
                            SizedBox(
                              width: 20.w,
                            ),
                            SvgPicture.asset(
                              SvgImg.upDownIcon,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 39.h),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Добавить события',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff171717),
                          ),
                        ),
                        Text(
                          'Выделено: 2 событий',
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
                    Container(
                      height: 35.h,
                      width: 35.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: const Color(0xffFF1D1D),
                            width: 1,
                          )),
                      child: Center(
                        child: SvgPicture.asset(
                          SvgImg.add,
                          height: 17.h,
                          width: 17.w,
                          color: const Color(0xffFF1D1D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 308.h,
                width: 378.w,
                child: ListView(
                  children: [
                    ...List.generate(
                      20,
                      (index) => Container(
                          margin: EdgeInsets.symmetric(vertical: 8.h),
                          child: const UserTag()),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 17.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: 60.h,
                      child: CustomButton(
                        color: ColorStyles.redColor,
                        text: 'Создать событие',
                        validate: true,
                        code: false,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        svg: 'assets/icons/close_event_create.svg',
                        svgHeight: 22.h,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: CustomButton(
                          color: ColorStyles.accentColor,
                          text: 'Создать тег',
                          // validate: isValidate(),
                          code: false,
                          textColor: Colors.white,
                          onPressed: () {}),
                    )
                  ],
                ),
              ),
              // SizedBox(
              //   height: 308.h,
              //   child: ListView.builder(
              //     itemBuilder: (context, index) {
              //       return Container();
              //     },
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
