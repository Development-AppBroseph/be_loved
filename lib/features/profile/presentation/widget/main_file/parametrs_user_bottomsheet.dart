import 'package:be_loved/core/bloc/auth/auth_bloc.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/core/widgets/buttons/custom_animation_button.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/cubit/sub_cubit.dart';
import 'package:be_loved/features/profile/presentation/bloc/profile/cubit/sub_state.dart';
import 'package:be_loved/features/profile/presentation/views/second_subcription.dart';
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
                  //   Container(
                  //       // height: 275,
                  //       )
                  // else
                  if (state is SubHaveState)
                    if (context.read<AuthBloc>().user!.testEnd != null &&
                        context.read<AuthBloc>().user!.isTest)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            Text(
                              'Пробный период активен до ${getDate(context.read<AuthBloc>().user!.testEnd!)}',
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: ClrStyle
                                    .greyToBlack17[sl<AuthConfig>().idx],
                              ),
                            ),
                            // RichText(
                            //   text: TextSpan(
                            //     text: 'Пробный период активен до ',
                            //     style: TextStyle(
                            //       fontFamily: "Inter",
                            //       fontSize: 25.sp,
                            //       fontWeight: FontWeight.bold,
                            //       color: ClrStyle
                            //           .black17ToWhite[sl<AuthConfig>().idx],
                            //     ),
                            //     children: [
                            //       TextSpan(
                            //         text: getDate(context
                            //             .read<AuthBloc>()
                            //             .user!
                            //             .testEnd!),
                            //         style: TextStyle(
                            //           fontFamily: "Inter",
                            //           fontSize: 25.sp,
                            //           fontWeight: FontWeight.bold,
                            //           color: ColorStyles.accentColor,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // Row(
                            //   children: [
                            //     Text(
                            //       'Подписка',
                            //       style: TextStyle(
                            //         fontFamily: "Inter",
                            //         fontSize: 25.sp,
                            //         fontWeight: FontWeight.bold,
                            //         color: ClrStyle
                            //             .black17ToWhite[sl<AuthConfig>().idx],
                            //       ),
                            //     ),
                            //     Text(
                            //       ' BeLoved+',
                            //       style: TextStyle(
                            //         fontFamily: "Inter",
                            //         fontSize: 25.sp,
                            //         fontWeight: FontWeight.bold,
                            //         color: const Color(0xffFF3347),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    // builder: (context) => SubscriptionView(),
                                    builder: (context) =>
                                        SecondSubscriptionView(),
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
                                            child: Align(
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
                                          '199₽ в год',
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
                  if (state is SubHaveState)
                    if (context.read<AuthBloc>().user!.subEnd != null &&
                        context.read<AuthBloc>().user!.isTest == false)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          children: [
                            Text(
                              'Подписка активна до ${getDate(context.read<AuthBloc>().user!.subEnd!)}',
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: ClrStyle
                                    .greyToBlack17[sl<AuthConfig>().idx],
                              ),
                            ),
                            // Row(
                            //   children: [
                            //     Text(
                            //       'Подписка',
                            //       style: TextStyle(
                            //         fontFamily: "Inter",
                            //         fontSize: 25.sp,
                            //         fontWeight: FontWeight.bold,
                            //         color: ClrStyle
                            //             .black17ToWhite[sl<AuthConfig>().idx],
                            //       ),
                            //     ),
                            //     Text(
                            //       ' BeLoved+',
                            //       style: TextStyle(
                            //         fontFamily: "Inter",
                            //         fontSize: 25.sp,
                            //         fontWeight: FontWeight.bold,
                            //         color: const Color(0xffFF3347),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.of(context).pop();
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     // builder: (context) => SubscriptionView(),
                                //     builder: (context) =>
                                //         SecondSubscriptionView(),
                                //   ),
                                // );
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
                                  // child: Stack(
                                  //   children: [
                                  //     Positioned(
                                  //       bottom: 15,
                                  //       left: 20,
                                  //       child: SizedBox(
                                  //         height: 36.h,
                                  //         width: 144.w,
                                  //         child: CupertinoCard(
                                  //           elevation: 0,
                                  //           radius: BorderRadius.circular(20),
                                  //           margin: EdgeInsets.zero,
                                  //           padding: EdgeInsets.zero,
                                  //           child: Align(
                                  //             alignment: Alignment.center,
                                  //             child: Text(
                                  //               'Приобрести',
                                  //               style: TextStyle(
                                  //                 fontFamily: 'Inter',
                                  //                 fontSize: 18.sp,
                                  //                 fontWeight: FontWeight.w800,
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     Positioned(
                                  //       left: 184,
                                  //       bottom: 23,
                                  //       child: Text(
                                  //         '199₽ в месяц',
                                  //         style: TextStyle(
                                  //           fontFamily: 'Inter',
                                  //           fontSize: 18.sp,
                                  //           color: Colors.white,
                                  //           fontWeight: FontWeight.w800,
                                  //         ),
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  // else
                  //   DevideSettings(
                  //     title: "Подписка BeLoved+",
                  //     subtitle: "Подробнее",
                  //     haveToggleSwitch: false,
                  //     icon: SvgImg.person,
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           // builder: (context) => SubscriptionView(),
                  //           builder: (context) => SecondSubscriptionView(),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  SizedBox(
                    height: 40.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      context.read<AuthBloc>().add(LogOut(context));
                    },
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25.w),
                          color: Colors.transparent,
                          child: CustomAnimationButton(
                            red: true,
                            text: 'Выйти из аккаунта',
                            onPressed: () async {
                              Navigator.pop(context);
                              context.read<AuthBloc>().add(LogOut(context));
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25.w),
                          color: Colors.transparent,
                          height: 50.h,
                          width: double.infinity,
                        ),
                      ],
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

  String getDate(DateTime dateTime) {
    String date = '';
    if (dateTime.day < 10) {
      date = '0${dateTime.day}';
    } else {
      date = dateTime.day.toString();
    }
    if (dateTime.month < 10) {
      date = '$date.0${dateTime.month}';
    } else {
      date = '$date.${dateTime.month}';
    }
    date = date = '$date.${dateTime.year}';
    return date;
  }
}
