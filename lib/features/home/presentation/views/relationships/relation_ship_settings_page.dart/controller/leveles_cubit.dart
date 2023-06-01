import 'package:be_loved/core/services/database/auth_params.dart';
import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/usecases/get_levels.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ship_settings_page.dart/controller/levels_state.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ship_settings_page.dart/widgets/congratulation_widget.dart';
import 'package:be_loved/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LevelsCubit extends Cubit<LevelState> {
  final GetLevels getLevels;
  LevelsCubit({required this.getLevels}) : super(LevelEmptyState());
  bool isShwon = false;

  Future<void> fetchLevels() async {
    try {
      emit(LevelLoadingState());
      final data = await getLevels.call(NoParams());
      data.fold(
        (error) => emit(LevelErrorState(message: error.toString())),
        (result) => emit(
          LevelLoadedState(levels: result),
        ),
      );
    } catch (e) {
      emit(LevelErrorState(message: e.toString()));
    }
  }

  Future<void> anniversary(int days, BuildContext context) async {
    final result = await getLevels.call(NoParams());
    int year = days ~/ 365;
    print("YEAR:$year");

    result.fold((l) {
      return;
    }, (data) async {
      DateTime date = DateTime.parse(sl<AuthConfig>().user!.date ?? '');
      int day = date.day;
      int month = date.month;
      isShwon = await MySharedPrefs().getBoolYears() ?? false;
      if (day != DateTime.now().day && month != DateTime.now().month) {
        isShwon = false;
        await MySharedPrefs().setBoolYears(isShwon);
      } else if (day == DateTime.now().day &&
          month == DateTime.now().month &&
          !isShwon && year != 0) {
        isShwon = true;
        showMaterialModalBottomSheet(
          context: context,
          animationCurve: Curves.easeInOutQuint,
          duration: const Duration(
            milliseconds: 600,
          ),
          backgroundColor: Colors.transparent,
          builder: (context) {
            return CongratulationWidget(
              yaer: year,
            );
          },
        );
      }
      await MySharedPrefs().setBoolYears(isShwon);
      // if (previoseDay == 0 || year == 0) {
      //   previoseDay = year;
      //   await MySharedPrefs().setYears(previoseDay);
      //   return;
      // } else if (year == previoseDay) {
      //   return;
      // } else {
      //   previoseDay = year;

      //   await MySharedPrefs().setYears(previoseDay);
      // }
    });
  }
}
