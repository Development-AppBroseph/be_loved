import 'package:be_loved/features/home/presentation/views/relationships/relation_ship_settings_page.dart/controller/leveles_cubit.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ship_settings_page.dart/controller/levels_state.dart';
import 'package:be_loved/features/profile/presentation/widget/grey_line_for_bottomsheet.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CongratulationWidget extends StatefulWidget {
  final int yaer;
  const CongratulationWidget({
    Key? key,
    required this.yaer,
  }) : super(key: key);

  @override
  State<CongratulationWidget> createState() => _CongratulationWidgetState();
}

class _CongratulationWidgetState extends State<CongratulationWidget> {
  final Shader linearGradient = const LinearGradient(
    colors: [
      Color(0xff0077FF),
      Color(0xffFF3347),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 732.h,
      child: CupertinoCard(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        radius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: BlocBuilder<LevelsCubit, LevelState>(
          builder: (context, state) {
            if (state is LevelEmptyState) {
              context.read<LevelsCubit>().fetchLevels();
            }
            return Column(
              children: [
                const BottomSheetGreyLine(),
                Text(
                  'С годовщиной!',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Text(
                            'От команды BeLoved ->',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              foreground: Paint()..shader = linearGradient,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Text(
                            'Поздравляем с годовщиной от команды BeLoved!...',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: const Color(0xff969696),
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 287,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Text(
                            'Теперь вы:',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              foreground: Paint()..shader = linearGradient,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (state is LevelLoadedState)
                          ...List.generate(
                            1,
                            (index) => SizedBox(
                              height: 65.h,
                              width: double.infinity,
                              child: CupertinoCard(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 25.w, vertical: 5.h),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        'https://beloved-app.ru${state.levels.where((element) => element.years == widget.yaer).toList()[index].image}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 65.h,
                            width: double.infinity,
                            child: CupertinoCard(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 25.w, vertical: 5.h),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 60,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                                border: Border.all(
                                    color: const Color(0xff0077FF), width: 2)),
                            margin: EdgeInsets.symmetric(horizontal: 25.w),
                            padding: EdgeInsets.zero,
                            height: 60,
                            width: double.infinity,
                            alignment: Alignment.center,
                            // child: CupertinoCard(
                            //   radius: BorderRadius.circular(15),
                            //   color: Colors.white,
                            //   elevation: 10,
                            //   decoration: BoxDecoration(
                            //       border: Border.all(
                            //           color: const Color(0xff0077FF),
                            //           width: 2)),
                            // ),
                            child: const Text(
                              'Спасибо',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff0077FF),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
