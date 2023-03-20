import 'package:equatable/equatable.dart';

abstract class HomeInfoFirstState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInfoFirstEmptyState extends HomeInfoFirstState {
  @override
  List<Object?> get props => [];
}

class HomeInfoFirstOnlyMinutesState extends HomeInfoFirstState {
  final int minutes;

  HomeInfoFirstOnlyMinutesState({
    required this.minutes,
  });
  @override
  List<Object?> get props => [minutes];
}

class HomeInfoFirstOnlyHoursAndMinutesState extends HomeInfoFirstState {
  final int hours;
  final int minutes;

  HomeInfoFirstOnlyHoursAndMinutesState({
    required this.hours,
    required this.minutes,
  });
  @override
  List<Object?> get props => [hours, minutes];
}

class HomeInfoFirstOnlyDayHoursAndMinutesState extends HomeInfoFirstState {
  final int days;
  final int hours;
  final int minutes;

  HomeInfoFirstOnlyDayHoursAndMinutesState({
    required this.days,
    required this.hours,
    required this.minutes,
  });
}

class HomeInfoFirstMonthDaysAndHours extends HomeInfoFirstState {
  final int month;
  final int days;
  final int hours;

  HomeInfoFirstMonthDaysAndHours({
    required this.month,
    required this.days,
    required this.hours,
  });
  @override
  List<Object?> get props => [month, days, hours];
}

class HomeInfoFirstMonthDaysHoursAndMinutes extends HomeInfoFirstState {
  final int month;
  final int days;
  final int hours;
  final int minutes;

  HomeInfoFirstMonthDaysHoursAndMinutes({
    required this.month,
    required this.days,
    required this.hours,
    required this.minutes,
  });
  @override
  List<Object?> get props => [month, days, hours, minutes];
}

class HomeInfoFirstYearsMonthsAndDays extends HomeInfoFirstState {
  final int years;
  final int months;
  final int days;

  HomeInfoFirstYearsMonthsAndDays({
    required this.years,
    required this.months,
    required this.days,
  });
  @override
  List<Object?> get props => [years, months, days];
}
