import 'package:shared_preferences/shared_preferences.dart';

class Controller{
  static Future<bool>  getLoggedInUser() async{
    final prefs = await SharedPreferences.getInstance();
    var answer = await prefs.getBool("isLoggedIn");
    if(answer!=null){
      if(answer){
       return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }
}