import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/core/widgets/text_fields/default_text_form_field.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SendFilesWidget extends StatefulWidget {
  const SendFilesWidget({Key? key}) : super(key: key);

  @override
  State<SendFilesWidget> createState() => _SendFilesWidgetState();
}

class _SendFilesWidgetState extends State<SendFilesWidget> {
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60.h,
                  ),
                  SizedBox(
                    width: 378.w,
                    height: 38.h,
                    child: ClipPath.shape(
                        shape:
                            SquircleBorder(radius: BorderRadius.circular(20.r)),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Container(
                                color: ColorStyles.blackColor,
                              ),
                            ),
                            Positioned.fill(
                              right: 240.w,
                              child: Container(
                                color: ColorStyles.primarySwath,
                              ),
                            ),
                            Positioned.fill(
                              left: 20.w,
                              right: 20.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Хранилище:',
                                    style: TextStyles(context).white_15_w800,
                                  ),
                                  Text(
                                    '10/100 ГБ',
                                    style: TextStyles(context).white_15_w800,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    'Отправим файлы на почту',
                    style: TextStyles(context).black_20_w800,
                  ),
                  Text(
                    'Письмо придёт в ближайшее время',
                    style: TextStyles(context).grey_15_w700,
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  DefaultTextFormField(
                    hint: 'E-mail',
                    maxLines: 1,
                    controller: _controller,
                    maxLength: 40,
                    hideCounter: true,
                  ),
                  SizedBox(
                    height: 77.h,
                  ),
                  CustomButton(
                    color: ColorStyles.primarySwath,
                    text: 'Готово',
                    textColor: Colors.white,
                    onPressed: () {},
                  ),
                ],
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
                      'Выгрузить данные',
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
