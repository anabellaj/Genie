import 'dart:convert';

import 'package:genie_app/models/connection.dart';
import 'package:genie_app/models/user.dart';
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

  static Future<User> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    var user = await prefs.getString("user");
    User loggedUser;
    if(user!=null){
      loggedUser = User.fromJson(jsonDecode(user));

      return loggedUser;

    }else{
      return User("", "");
    }
  }

  static String getListInfo(List<dynamic> list){
    String res='';
    for(var i in list){
      res+= i+",";
    }
    return res;
  }

  static Future<String> updateUserInfo(User userInfo) async{
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("user", jsonEncode(userInfo.toJson()));
      await Connection.updateUser(userInfo);
      return 'success';
    } catch (e) {
      return 'error';
    }
    
    
    
  }

  static Future<String> logOutUser()async{
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.setString("user", "");

      return "success";
      
    } catch (e) {
      return "error";
    }
  }

  static Future<String> removeUser(User user)async{
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.setString("user", "");

      await Connection.removeUser(user);


      return "success";

      
    } catch (e) {
      return "error";
    }
  }
}