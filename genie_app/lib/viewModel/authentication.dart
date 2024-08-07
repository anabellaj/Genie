import 'dart:convert';
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Authenticate{

  static Future<String> registerUser(String email, String password, String name, String username) async{
    try {
      final prefs = await SharedPreferences.getInstance();

      User user = User(email, password);
      user.name = name;
      user.username = username;
      user.initialize();

      final result = await Connection.checkUser(user);
      

      
      if(!result.isNotEmpty){
        String followingId = await Connection.newFollowing();
        user.following= followingId;
        String id = await Connection.insertNewUser(user);
        user.id= id;
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString("user", jsonEncode(user.toJson()));
        return "success";
      }else{
        return "user_exists";
      }
    } catch (e) {
      print(e);
      return "error";
    }
  }

  static Future<String> loginUser(String email, String password) async{
    try {
      final prefs = await SharedPreferences.getInstance();
      User user = User(email, password);
      user.initialize();

      final result = await Connection.checkUser(user);
      
      if(result.isNotEmpty){
        
        if(result[0]["password"]==password){
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString("user", jsonEncode(User.fromJson(result[0])) );
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