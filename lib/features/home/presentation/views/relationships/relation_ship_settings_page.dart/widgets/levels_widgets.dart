import 'package:be_loved/features/home/presentation/views/relationships/relation_ship_settings_page.dart/controller/leveles_cubit.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ship_settings_page.dart/controller/levels_state.dart';
import 'package:be_loved/features/profile/presentation/widget/grey_line_for_bottomsheet.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LevelsWidget extends StatelessWidget {
  final DateTime dateTime;
  const LevelsWidget({Key? key, required this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentYear =
        (dateTime.difference(DateTime.now()).inDays / 365 * -1).toInt();
    return SizedBox(
      height: 732.h,
      child: CupertinoCard(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        radius: BorderRadius.circular(40),
        child: BlocBuilder<LevelsCubit, LevelState>(
          builder: (context, state) {
            if (state is LevelEmptyState) {
              context.read<LevelsCubit>().fetchLevels();
            } else if (state is LevelLoadedState) {
              return Column(
                children: [
                  const BottomSheetGreyLine(),
                  Text(
                    'Уровни отношений',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: const Color(0xff969696),
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  SizedBox(
                    height: 677.h,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          state.levels.length,
                          (index) => SizedBox(
                            height: 65.h,
                            width: double.infinity,
                            child: CupertinoCard(
                              color: Colors.grey,
                              margin: EdgeInsets.symmetric(
                                horizontal: 25.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://beloved-app.ru${state.levels[index].image}',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: 20.w, bottom: 1.h),
                                      child: CupertinoCard(
                                        radius: BorderRadius.circular(28.r),
                                        decoration: BoxDecoration(
                                          color: currentYear >=
                                                  state.levels[index].years
                                              ? Colors.white
                                              : const Color.fromRGBO(
                                                  150, 150, 150, 1),
                                        ),
                                        child: Container(
                                          width: 89.w,
                                          height: 39.h,
                                          alignment: Alignment.center,
                                          child: Text(
                                            getNoun(state.levels[index].years),
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: currentYear >=
                                                      state.levels[index].years
                                                  ? const Color.fromRGBO(
                                                      23, 23, 23, 1)
                                                  : const Color.fromRGBO(
                                                      208, 208, 208, 1),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: Container(),
            );
          },
        ),
      ),
    );
  }

  String getNoun(int count) {
    if (count == 228) {
      return '40+';
    }
    if (count.toString().endsWith('1') && count != 11) {
      return '$count год';
    }
    if (count.toString().endsWith('2') && count != 12) {
      return '$count года';
    }
    if (count.toString().endsWith('3') && count != 13) {
      return '$count года';
    }
    if (count.toString().endsWith('4') && count != 14) {
      return '$count года';
    }
    return '$count лет';
  }
}
