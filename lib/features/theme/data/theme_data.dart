import 'package:shared_preferences/shared_preferences.dart';

const String SELECTED_THEME = 'theme';


setTheme(int index) async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setInt(SELECTED_THEME, index);
}


Future<int> getThemeIndex() async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  return sp.getInt(SELECTED_THEME) ?? 0;
}