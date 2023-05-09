import 'package:be_loved/core/services/database/shared_prefs.dart';
import 'package:be_loved/core/usecases/usecase.dart';
import 'package:be_loved/features/home/domain/usecases/get_levels.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ship_settings_page.dart/controller/levels_state.dart';
import 'package:be_loved/features/home/presentation/views/relationships/relation_ship_settings_page.dart/widgets/congratulation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LevelsCubit extends Cubit<LevelState> {
  final GetLevels getLevels;
  LevelsCubit({required this.getLevels}) : super(LevelEmptyState());
  int previoseDay = 0;

  
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
    previoseDay = await MySharedPrefs().year ?? 0;
    result.fold((l) {
      return;
    }, (data) async {
      if (year != previoseDay) {
        previoseDay = year;
        await MySharedPrefs().setYears(previoseDay);
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
    });
  }
}
