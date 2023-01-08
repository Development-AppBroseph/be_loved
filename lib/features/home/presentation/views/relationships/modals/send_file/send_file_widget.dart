import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/core/widgets/text_fields/default_text_form_field.dart';
import 'package:be_loved/features/home/presentation/views/archive/presentation/widgets/memory_info_card.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
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
      color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
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
                  MemoryInfoCard(),
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
                    border: sl<AuthConfig>().idx == 0 ? null : Border.all(width: 2.w, color: ColorStyles.white),
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
                  color: ClrStyle.whiteTo17[sl<AuthConfig>().idx]
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
