import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/models/user.dart';
import 'package:genie_app/view/widgets/group_preview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Controller{

  static Future<String> updateUsersGroupsAndMembers(String enterCode) async{
      String responseGroupId = await Connection.checkStudyGroupCode(enterCode);
      if(responseGroupId == "no success"){
        return "no success";
      } else{
      User loggedUser = await Controller.getUserInfo();
      List logUser = await Connection.checkUser(loggedUser);
      print (!loggedUser.studyGroups.contains(responseGroupId));
      
      if(!loggedUser.studyGroups.contains(responseGroupId)){
      loggedUser.studyGroups.add(responseGroupId);
      updateUserInfo(loggedUser);
      List result = await Connection.checkStudyGroup(responseGroupId);
      Groups currentGroup = Groups.fromJson(result[0]);
      print(currentGroup.members);
      currentGroup.members.add(logUser[0]["_id"].oid);
      print(currentGroup.members);
      Connection.updateGroupMembers(responseGroupId, currentGroup.members);
      
      return "success";
      }
      else {
        return "already on group";
      }
      }
  }
  

  static Future<Widget> getUserGroups() async{
    User loggedUser = await Controller.getUserInfo();
    List stGroups = loggedUser.studyGroups;
    List<Widget> obtainedGroups = [];
    for (String groupId in stGroups){
     List gr = await Connection.checkStudyGroup(groupId);
     if(gr.isNotEmpty){
     obtainedGroups.add(GroupPreview(name: gr[0]["name"], membersQty: gr[0]["members"].length.toString(), description: gr[0]["description"], group: Groups.fromJson(gr[0])));
     }
    }
    
    return ListView(
      children: obtainedGroups,
    );
  }

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