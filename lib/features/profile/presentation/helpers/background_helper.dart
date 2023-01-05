


import 'package:be_loved/constants/main_config_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String SELECTED_BACK = 'back';
const String ALL_BACKS = 'all_backs_decor';

addBackground(String image) async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  List<String>? list = sp.getStringList(ALL_BACKS);
  if(list != null){
    list = list.reversed.toList();
    list.add(image);
    list = list.reversed.toList();
    sp.setStringList(ALL_BACKS, list);
  }else{
    sp.setStringList(ALL_BACKS, [image, ...MainConfigApp.decorBackgrounds]);
  }
}


Future<List<String>> getBackgrounds() async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  List<String>? list = sp.getStringList(ALL_BACKS);
  return list ?? MainConfigApp.decorBackgrounds;
}

setBackground(int index) async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setInt(SELECTED_BACK, index);
}


Future<int> getBackgroundIndex() async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.getInt(SELECTED_BACK) ?? 0;
}