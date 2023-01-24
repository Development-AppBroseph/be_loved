
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String convertToAgo(DateTime input){
  Duration diff = DateTime.now().difference(input);
  
  if(diff.inDays >= 1){
    return '${diff.inDays} д. назад';
  } else if(diff.inHours >= 1){
    return '${diff.inHours} ч. назад';
  } else if(diff.inMinutes >= 1){
    return '${diff.inMinutes} м. назад';
  } else if (diff.inSeconds >= 1){
    return '${diff.inSeconds} с. назад';
  } else {
    return 'just now';
  }
}




String checkDays(String days) {
  int _days = int.parse(days);
  int lastNumber = int.parse(days[days.length - 1]);
  if(_days == 0){
    return 'Сегодня';
  }
  if(_days == 1){
    return 'Завтра';
  }
  if(_days == 7){
    return 'Через неделю';
  }
  if(_days == 14){
    return 'Через 2 недели';
  }
  if(_days == 21){
    return 'Через 3 недели';
  }
  if(_days >= 29 && _days <= 31){
    return 'Через месяц';
  }
  DateTime _daysInDateTime = DateTime.now().add(Duration(days: _days));
  if(DateTime.now().year != _daysInDateTime.year){
    return DateFormat('dd.MM.yy').format(_daysInDateTime);
  }
  if(_days > 31){
    return DateFormat('dd.MM').format(_daysInDateTime);
  }
  if(lastNumber > 5 && lastNumber < 10) return 'Через $days дней';
  if(_days % 5 == 0) return 'Через $days дней';
  if(_days >= 11 && _days <= 20) return 'Через $days дней';
  if(lastNumber == 1) return 'Через $days день';
  return 'Через $days дня';
}



Color getColorFromDays(String days, bool isImportant){
  int daysP = int.parse(days);

  if(daysP <= 2 || isImportant){
    return ColorStyles.redColor;
  }
  if(daysP == 3){
    return ColorStyles.violet2Color;
  }
  if(daysP == 4){
    return ColorStyles.violetColor;
  }
  if(daysP == 5){
    return Color(0xFF4061C7);
  }
  return ColorStyles.blueColor;
}



getTextFromDate(String days, [String? additionString, bool showAllDate = false]){
  if(showAllDate){
    int _days = int.parse(days);
    DateTime _daysInDateTime = DateTime.now().add(Duration(days: _days));
    if(DateTime.now().year != _daysInDateTime.year){
      return DateFormat('dd.MM.yy').format(_daysInDateTime);
    }
    return DateFormat('dd.MM').format(_daysInDateTime);
  }
  bool isTomorrow = days == '1';
  bool isToday = days == '0';
  return isTomorrow
      ? 'Завтра${additionString ?? ''}'
      : isToday
      ? 'Сегодня${additionString ?? ''}'
      : '${checkDays(days)}${additionString ?? ''}';
}






String purposeDays(String days) {
  int _days = int.parse(days);
  int lastNumber = int.parse(days[days.length - 1]);
  if(_days <= 1){
    return 'Остался день';
  }
  if(_days >= 29 && _days <= 31){
    return 'Остался 1 месяц';
  }
  if(lastNumber > 5 && lastNumber < 10) return 'Осталось $days дней';
  if(_days % 5 == 0) return 'Осталось $days дней';
  if(_days >= 11 && _days <= 20) return 'Осталось $days дней';
  if(lastNumber == 1) return 'Остался $days день';
  return 'Осталось $days дня';
}

String purposeTimes(Duration time) {
  if(time.inHours >= 1){
    return 'Осталось ${time.inHours} час.';
  }
  if(time.inMinutes <= 1){
    return 'Осталось 1 минута';
  }
  return 'Осталось ${time.inMinutes} минут';
}




bool isOneDay(DateTime first, DateTime second){
  return first.year == second.year && first.month == second.month && first.day == second.day;
}