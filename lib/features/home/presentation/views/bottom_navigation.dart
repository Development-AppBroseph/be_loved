import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/utils/images.dart';
import 'package:be_loved/features/home/presentation/bloc/main_screen/main_screen_bloc.dart';
import 'package:be_loved/features/theme/data/entities/clr_style.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';



class BottomNavigation extends StatelessWidget {
  final Function()? onTap;
  BottomNavigation({this.onTap});

  @override
  Widget build(BuildContext context) {
    TextStyle styleSelect = const TextStyle(
        fontWeight: FontWeight.w700, fontSize: 12, color: ColorStyles.redColor);
    TextStyle styleUnSelect = const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12,
        color: ColorStyles.greyColor);

    MainScreenBloc bloc = context.read<MainScreenBloc>();
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        return Container(
          height: 100.h,
          color: ClrStyle.whiteTo17[sl<AuthConfig>().idx],
          child: Padding(
            padding: EdgeInsets.only(bottom: 26.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    bloc.add(ChangeViewEvent(view: 0));
                    onTap != null ? onTap!() : null;
                  },
                  child: Container(
                    width: 93.w,
                    height: 74.h,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 11.h),
                        SvgPicture.asset(
                          SvgImg.relationships,
                          height: 32.h,
                          width: 37.w,
                          color: bloc.currentView == 0
                              ? ColorStyles.redColor
                              : Colors.grey,
                        ),
                        SizedBox(height: 12.h),
                        Text('Отношения',
                            style: bloc.currentView == 0
                                ? styleSelect
                                : styleUnSelect),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    bloc.add(ChangeViewEvent(view: 1));
                    onTap != null ? onTap!() : null;
                  },
                  child: Container(
                    width: 93.w,
                    height: 74.h,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 11.h),
                        SvgPicture.asset(
                          SvgImg.events,
                          height: 32.h,
                          width: 28.24.w,
                          color: bloc.currentView == 1
                              ? ColorStyles.redColor
                              : Colors.grey,
                        ),
                        SizedBox(height: 12.h),
                        Text('События',
                            style: bloc.currentView == 1
                                ? styleSelect
                                : styleUnSelect),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    bloc.add(ChangeViewEvent(view: 2));
                    onTap != null ? onTap!() : null;
                  },
                  child: Container(
                    width: 93.w,
                    height: 74.h,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 11.h),
                        SvgPicture.asset(
                          SvgImg.purposes,
                          height: 32.h,
                          width: 32.w,
                          color: bloc.currentView == 2
                              ? ColorStyles.redColor
                              : Colors.grey,
                        ),
                        SizedBox(height: 12.h),
                        Text('Цели',
                            style: bloc.currentView == 2
                                ? styleSelect
                                : styleUnSelect),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    bloc.add(ChangeViewEvent(view: 3));
                    onTap != null ? onTap!() : null;
                  },
                  child: Container(
                    width: 93.w,
                    height: 74.h,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 11.h),
                        SvgPicture.asset(
                          SvgImg.archive,
                          height: 32.h,
                          width: 29.26.w,
                          color: bloc.currentView == 3
                              ? ColorStyles.redColor
                              : Colors.grey,
                        ),
                        SizedBox(height: 12.h),
                        Text('Архив',
                            style: bloc.currentView == 3
                                ? styleSelect
                                : styleUnSelect),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}