
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
  if(lastNumber > 5 && lastNumber < 10) return 'дней';
  if(_days % 5 == 0) return 'дней';
  if(_days == 11) return 'дней';
  if(lastNumber == 1) return 'день';
  return 'дня';
}