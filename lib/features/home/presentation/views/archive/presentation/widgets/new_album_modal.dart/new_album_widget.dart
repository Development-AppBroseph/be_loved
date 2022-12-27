import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/core/widgets/text_fields/default_text_form_field.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/icon_select_modal.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../../../core/utils/helpers/widget_position_helper.dart';

class NewAlbumWidget extends StatefulWidget {
  const NewAlbumWidget({Key? key}) : super(key: key);

  @override
  State<NewAlbumWidget> createState() => _NewAlbumWidgetState();
}

class _NewAlbumWidgetState extends State<NewAlbumWidget> {
  final ScrollController scrollController = ScrollController();
  GlobalKey iconBtn = GlobalKey();
  int iconIndex = 15;

  showIconModal() async {
    await scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOutQuint);
    iconSelectModal(
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

  TextStyle style2 = TextStyle(
      color: ColorStyles.blackColor,
      fontSize: 18.sp,
      fontWeight: FontWeight.w800);

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CupertinoCard(
      radius: BorderRadius.vertical(
        top: Radius.circular(80.r),
      ),
      elevation: 0,
      margin: EdgeInsets.zero,
      child: SizedBox(
        height: 455.h,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60.h,
                    ),
                    DefaultTextFormField(
                      hint: 'Название',
                      maxLines: 1,
                      controller: _controller,
                      maxLength: 40,
                      hideCounter: true,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      height: 57.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: ColorStyles.backgroundColorGrey),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Иконка',
                            style: style2,
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: showIconModal,
                              onPanEnd: (d) {
                                showIconModal();
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Row(
                                children: [
                                  iconIndex == 15
                                      ? SvgPicture.asset(
                                          'assets/icons/no_icon.svg',
                                          height: 28.h,
                                          key: iconBtn,
                                        )
                                      : Image.asset(
                                          Img.smile,
                                          height: 33.h,
                                          width: 33.h,
                                          key: iconBtn,
                                        ),
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
                      padding: EdgeInsets.only(top: 20.h),
                      child: SizedBox(
                        height: 65.h,
                        width: 428.w,
                        child: CupertinoCard(
                          margin: EdgeInsets.all(0.h),
                          elevation: 0,
                          color: const Color(0xffF0F0F0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(right: 26.w, left: 19.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 20.w),
                                  child: SvgPicture.asset(
                                    SvgImg.camera,
                                    height: 23.h,
                                    width: 26.w,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Добавить файлы',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const Spacer(),
                                SvgPicture.asset(
                                  SvgImg.addNewEvent,
                                  color: Colors.black,
                                  height: 22.h,
                                  width: 22.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    CustomButton(
                      color: ColorStyles.primarySwath,
                      text: 'Создать альбом',
                      textColor: Colors.white,
                      validate: true,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              top: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28.h),
                    topRight: Radius.circular(28.h),
                  ),
                  color: Colors.white,
                ),
                padding: EdgeInsets.fromLTRB(0, 7.h, 0, 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 100.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        color: ColorStyles.greyColor,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Новый альбом',
                      style: TextStyles(context).grey_15_w800,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
