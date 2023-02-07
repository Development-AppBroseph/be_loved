import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/widgets/buttons/custom_animation_button.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/send_file/send_file_modal.dart';
import 'package:be_loved/features/profile/presentation/views/parting_second_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PartingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/back.png',
            width: MediaQuery.of(
              context,
            ).size.width,
            height: 690.h,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 530.h,
              width: MediaQuery.of(
                context,
              ).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    Colors.black,
                    Colors.black,
                    Colors.black.withOpacity(0),
                  ])),
            ),
          ),
          Positioned.fill(
              top: 605.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyles(context).white_35_w800,
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Ты точно уверен',
                        ),
                        TextSpan(
                            text: '(а)',
                            style: TextStyles(context)
                                .black_35_w800
                                .copyWith(color: ColorStyles.blackColor)),
                        const TextSpan(
                          text: '?',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    'Расставание — не выход.',
                    style: TextStyles(context).grey_15_w800,
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: CustomAnimationButton(
                      text: 'Зажми, чтобы подтвердить',
                      // color: ColorStyles.redColor,
                      red: true,
                      onPressed: () async {
                        bool? isPart =
                            await showModalSendFile(context, isParting: true);
                        if (isPart != null && isPart) {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (BuildContext context) =>
                                      PartingSecondView()));
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: CustomButton(
                      color: ColorStyles.white,
                      text: 'Отмена',
                      textColor: ColorStyles.blackColor,
                      validate: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
