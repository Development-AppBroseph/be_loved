int textSizeByLength(String text){
  if(text.length <= 6){
    return 25;
  }
  if(text.length <= 8){
    return 20;
  }
  return 18;
}