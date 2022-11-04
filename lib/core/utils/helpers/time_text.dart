


bool timeTextHelper(String validateText){
  bool validated = true;
  if(validateText.length == 5){
    if(int.parse(validateText[0]) > 2){
      validated = false;
    }else if(int.parse(validateText[0]) == 2 && int.parse(validateText[1]) > 3){
      validated = false;
    }else if(int.parse(validateText[3]) > 5){
      validated = false;
    }
  }else{
    validated = false;
  }
  return validated;
}