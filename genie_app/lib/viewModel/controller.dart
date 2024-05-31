import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/models/forum.dart';
import 'package:genie_app/models/user.dart';
import 'package:genie_app/view/widgets/forum_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


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

  static Future<String> createNewForum(String title, String description)async {
    
    try {
      final prefs = await SharedPreferences.getInstance();
      var user = await prefs.getString("user");
      if(user != null){
        User loggedUser = User.fromJson(jsonDecode(user));
        String creator = loggedUser.name;
        DateTime date = DateTime.now();

        Forum newForum = Forum(title, description, creator, date);
        newForum.initialize();

       await Connection.addNewForum(newForum);


        return 'success';



      }else{
        return 'error';
      }

    } catch (e) {
      return 'error';
    }
  }

  static Future<Widget> getForums()async{
    List forums = await Connection.returnForums("66552c763656b63721956447");

    List<Widget> previews = [];

    for (var forum in forums) {
      Forum f = Forum.fromJson(forum);
      previews.add(
        MessagePreview(title: f.title, creator: f.creator, date: DateFormat.yMd().format(f.date), description: f.description)
      );
    }

    return ListView(
      children: previews,
    );
  }
}