
import 'package:be_loved/constants/colors/color_styles.dart';
import 'package:flutter/material.dart';

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
  if(lastNumber > 5 && lastNumber < 10) return 'Через $days дней';
  if(_days % 5 == 0) return 'Через $days дней';
  if(_days == 11) return 'Через $days дней';
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



getTextFromDate(String days, [String? additionString]){
  bool isTomorrow = days == '1';
  bool isToday = days == '0';
  return isTomorrow
      ? 'Завтра${additionString ?? ''}'
      : isToday
      ? 'Сегодня${additionString ?? ''}'
      : '${checkDays(days)}${additionString ?? ''}';
}