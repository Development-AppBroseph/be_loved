import 'package:be_loved/features/home/presentation/views/relationships/widgets/home_info_first/controller/home_info_first_state.dart';
import 'package:bloc/bloc.dart';

class HomeInfoFirstCubit extends Cubit<HomeInfoFirstState> {
  HomeInfoFirstCubit() : super(HomeInfoFirstEmptyState());

  Future<void> getTime(
    int days,
    int hour,
    int minute,
    int years,
    int month,
    int daysInYears,
  ) async {
    if (days == 0 &&
        hour == 0 &&
        years == 0 &&
        month == 0 &&
        daysInYears == 0) {
      emit(HomeInfoFirstOnlyMinutesState(minutes: minute));
    } else if (days == 0 && years == 0 && month == 0 && daysInYears == 0) {
      emit(HomeInfoFirstOnlyHoursAndMinutesState(hours: hour, minutes: minute));
    } else if (years == 0 && month == 0) {
      emit(HomeInfoFirstOnlyDayHoursAndMinutesState(
          days: days, hours: hour, minutes: minute));
    } else if (years == 0 && minute == 0) {
      emit(HomeInfoFirstMonthDaysAndHours(
          month: month, days: daysInYears, hours: hour));
    } else if (years == 0) {
      emit(HomeInfoFirstMonthDaysHoursAndMinutes(
          month: month, days: daysInYears, hours: hour, minutes: minute));
    }else {
      emit(HomeInfoFirstYearsMonthsAndDays(years: years, months: month, days: daysInYears));
    }
  }
}
