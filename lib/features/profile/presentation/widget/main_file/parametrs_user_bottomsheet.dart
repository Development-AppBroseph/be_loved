import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/custom_animation_button.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/cubit/sub_cubit.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/cubit/sub_state.dart';
import 'package:be_loved/features/profile/presentation/views/subscription_view.dart';
import 'package:be_loved/features/profile/presentation/widget/decor/decor_modal.dart';
import 'package:be_loved/features/profile/presentation/widget/devides_settings.dart';
import 'package:be_loved/features/profile/presentation/widget/grey_line_for_bottomsheet.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParametrsUserBottomsheet extends StatefulWidget {
  final Function() onRelationSettingsTap;
  const ParametrsUserBottomsheet(
      {Key? key, required this.onRelationSettingsTap})
      : super(key: key);

  @override
  State<ParametrsUserBottomsheet> createState() =>
      _ParametrsUserBottomsheetState();
}

class _ParametrsUserBottomsheetState extends State<ParametrsUserBottomsheet> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubCubit, SubState>(
      builder: (context, state) {
        if (state is SubEmptyState) {
          context.read<SubCubit>().getStatus();
        }
        return CupertinoCard(
          radius: BorderRadius.vertical(
            top: Radius.circular(80.r),
          ),
          color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
          elevation: 0,
          margin: EdgeInsets.zero,
          child: SizedBox(
            height: 707.h,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  const BottomSheetGreyLine(),
                  Text(
                    'Меню',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: const Color(0xff969696),
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  // const AvatarAndNameUser(),
                  SizedBox(
                    height: 16.h,
                  ),
                  DevideSettings(
                    title: "Аккаунт",
                    subtitle: "Информация",
                    haveToggleSwitch: false,
                    icon: SvgImg.person,
                    onPressed: () => Navigator.pop(context, 'account'),
                  ),
                  DevideSettings(
                    title: "Отношения",
                    subtitle: "Настроить",
                    haveToggleSwitch: false,
                    icon: SvgImg.logov2,
                    onPressed: widget.onRelationSettingsTap,
                  ),
                  // DevideSettings(
                  //   title: "Виджеты",
                  //   subtitle: "Настроить",
                  //   haveToggleSwitch: false,
                  //   icon: SvgImg.widgets,
                  // ),
                  DevideSettings(
                    title: "Оформление",
                    subtitle: "Изменить",
                    haveToggleSwitch: false,
                    icon: SvgImg.documents,
                    onPressed: () {
                      Navigator.pop(context);
                      showModalDecor(context, () {});
                    },
                  ),
                  DevideSettings(
                    title: "Уведомления",
                    subtitle: "от приложения",
                    haveToggleSwitch: true,
                    icon: SvgImg.notification,
                  ),
                  if (state is SubHaveState)
                    Container(
                        // height: 275,
                        )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Подписка',
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold,
                                  color: ClrStyle
                                      .black17ToWhite[sl<AuthConfig>().idx],
                                ),
                              ),
                              Text(
                                ' BeLoved+',
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xffFF3347),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubscriptionView(),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 160,
                              width: double.infinity,
                              child: CupertinoCard(
                                elevation: 0,
                                margin: EdgeInsets.zero,
                                padding: EdgeInsets.zero,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      Img.back,
                                    ),
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 15,
                                      left: 20,
                                      child: SizedBox(
                                        height: 36.h,
                                        width: 144.w,
                                        child: CupertinoCard(
                                          elevation: 0,
                                          radius: BorderRadius.circular(20),
                                          margin: EdgeInsets.zero,
                                          padding: EdgeInsets.zero,
                                          child:  Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Приобрести',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 184,
                                      bottom: 23,
                                      child: Text(
                                        '199₽ в месяц',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 18.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // : DevideSettings(
                  //     title: "Подписка BeLoved+",
                  //     subtitle: "Подробнее",
                  //     haveToggleSwitch: false,
                  //     icon: SvgImg.person,
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => SubscriptionView(),
                  //   ),
                  // );
                  //     },
                  //   ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 25.w),
                    child: CustomAnimationButton(
                      red: true,
                      text: 'Выйти из аккаунта',
                      onPressed: () async {
                        Navigator.pop(context);
                        context.read<AuthBloc>().add(LogOut(context));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 55.h,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
