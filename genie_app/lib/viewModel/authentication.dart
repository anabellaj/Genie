import 'dart:convert';
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Authenticate{

  static Future<String> registerUser(String email, String password, String name) async{
    try {
      final prefs = await SharedPreferences.getInstance();

      User user = User(email, password);
      user.name = name;
      user.initialize();

      final result = await Connection.checkUser(user);
      

      
      if(!result.isNotEmpty){
        await Connection.insertNewUser(user);
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString("user", jsonEncode(user.toJson()));
        return "success";
      }else{
        return "user_exists";
      }
    } catch (e) {
      return "error";
    }
  }

  static Future<String> loginUser(String email, String password) async{
    try {
      final prefs = await SharedPreferences.getInstance();
      User user = User(email, password);

      final result = await Connection.checkUser(user);
      
      if(result.isNotEmpty){
        
        if(result[0]["password"]==password){
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString("user", jsonEncode(result[0]));
          return "success";
        }else{
          return "wrong_credentials";
        }
      }else{
        return "user_doesnt_exist";
      }

      
    } catch (e) {
      print(e);
      return "error";
    }
  }

 

}