import 'package:be_loved/features/home/presentation/views/relationships/relation_ship_settings_page.dart/controller/leveles_cubit.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ship_settings_page.dart/controller/levels_state.dart';
import 'package:be_loved/features/profile/presentation/widget/grey_line_for_bottomsheet.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LevelsWidget extends StatelessWidget {
  const LevelsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 13),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          state.levels.length,
                          (index) => SizedBox(
                            height: 65.h,
                            width: double.infinity,
                            child: CupertinoCard(
                              margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 5.h),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage('https://beloved-app.ru${state.levels[index].image}'),
                                  fit: BoxFit.cover,
                                ),
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
            return const Center(
              child: Text('Loading....'),
            );
          },
        ),
      ),
    );
  }
}

