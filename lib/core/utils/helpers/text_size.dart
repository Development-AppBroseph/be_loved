int textSizeByLength(String text){
  if(text.length <= 6){
    return 25;
  }
  if(text.length <= 8){
    return 20;
  }
  return 18;
}

int homeWidgetTextSize(String text){
  if(text.length <= 10){
    return 50;
  }
  if(text.length <= 14){
    return 40;
  }
  if(text.length <= 20){
    return 30;
  }
  // if(text.length <= 30){
    return 25;
  // }
  
  // return 50;
}