import 'dart:async';

import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/constants/texts/text_styles.dart';
import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/widgets/buttons/custom_animation_button.dart';
import 'package:be_loved/core/widgets/buttons/custom_button.dart';
import 'package:be_loved/features/auth/presentation/views/login/invite_partner.dart';
import 'package:be_loved/features/home/presentation/views/relationships/modals/send_file/send_file_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class PartingSecondView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const SizedBox(
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Lottie.asset('assets/animations/Cycle.json'),
          ),
          Positioned.fill(
              top: 520.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Нам очень жаль :C',
                    style: TextStyles(context).white_35_w800,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    'Надеемся, что вы помиритесь и\nвернётесь к нам :)',
                    style: TextStyles(context).grey_15_w800,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 117.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: CustomButton(
                      color: ColorStyles.white,
                      text: 'Приглашение партнёра',
                      textColor: ColorStyles.blackColor,
                      validate: true,
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    InvitePartner(
                                      nextPage: () {},
                                      isParting: true,
                                      previousPage: () {},
                                      streamController: StreamController<int>(),
                                    )),
                            (s) => false);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: CustomButton(
                      color: Colors.black,
                      text: 'Выйти из аккаунта',
                      border:
                          Border.all(width: 3.w, color: ColorStyles.redColor),
                      textColor: ColorStyles.redColor,
                      validate: true,
                      onPressed: () {
                        context.read<AuthBloc>().add(LogOut(context));
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
