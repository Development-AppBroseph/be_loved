
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