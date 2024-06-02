import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:genie_app/models/connection.dart';

import 'package:genie_app/models/group.dart';
import 'package:genie_app/models/topic.dart';
import 'package:genie_app/models/user.dart';
import 'package:genie_app/view/screens/create_group.dart';
import 'package:genie_app/view/screens/join_or_create.dart';
import 'package:genie_app/view/screens/joined_groups.dart';
import 'package:genie_app/view/widgets/group_preview.dart';
import 'package:genie_app/view/widgets/member_preview.dart';

import 'package:genie_app/models/forum.dart';
import 'package:genie_app/view/screens/forum_view.dart';
import 'package:genie_app/view/widgets/forum_preview.dart';
import 'package:genie_app/view/widgets/forum_reply.dart';
import 'package:genie_app/models/forum_reply.dart';
import 'package:genie_app/view/widgets/topic_preview.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class Controller{

  static Future<Groups> updateGroupInfo(Groups group, String newDescr, String newName) async{
    Connection.setNewGroupInfo(newName, newDescr, group.id.oid);
    group.name = newName;
    group.description = newDescr;
    return group;
  }

  static Future<String> updateUsersGroupsAndMembers(String enterCode) async{
      String responseGroupId = await Connection.checkStudyGroupCode(enterCode);
      if(responseGroupId == "no success"){
        return "no success";
      } else{
      User loggedUser = await Controller.getUserInfo();
      List logUser = await Connection.checkUser(loggedUser);   
      if(!loggedUser.studyGroups.contains(responseGroupId)){
      loggedUser.studyGroups.add(responseGroupId);
      updateUserInfo(loggedUser);
      List result = await Connection.checkStudyGroup(responseGroupId);
      Groups currentGroup = Groups.fromJson(result[0]);
      currentGroup.members.add(logUser[0]["_id"].oid);
      Connection.updateGroupMembers(responseGroupId, currentGroup.members);
      
      return "success";
      }
      else {
        return "already on group";
      }
      }
  }
  static Future<Widget> obtainGroupMembers(List groupMembers,Groups group) async{
    List<User> members = await Connection.getGroupMembers(groupMembers);
    List<Widget> obtainedMembers = [];
    for (User u in members){
      obtainedMembers.add(MemberPreview(name: u.name, member: u, group: group));
    }
    return ListView(
      children: obtainedMembers,
    );
  }

  static Future<String> deleteMember(String memberId, Groups group) async{
    try{
    Connection.removeGroupMember(memberId, group);
    return "success";
    }catch (e){
      return "no_success";
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
    var answer = prefs.getBool("isLoggedIn");
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
    var user = prefs.getString("user");
    User loggedUser;
    if(user!=null){
      loggedUser = User.fromJson(jsonDecode(user));

      return loggedUser;

    }else{
      return User("", "");
    }
  }

  static Future<bool> checkAdminCurrUser(String memberId) async{
    User loggedUser = await Controller.getUserInfo();
    List logUser = await Connection.checkUser(loggedUser);

    if(logUser[0]["_id"].oid == memberId){
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> checkIsAdmin(Groups group) async{
    User loggedUser = await Controller.getUserInfo();
    List logUser = await Connection.checkUser(loggedUser);
    String logUserId = logUser[0]["_id"].oid;
    print(logUserId);
    print(group.admins);
    bool res = group.admins.contains(logUserId);
    print(res);
    return res;
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

  static Future<String> createNewForum(String title, String description, Groups group)async {
    
    try {
      final prefs = await SharedPreferences.getInstance();
      var user = prefs.getString("user");
      if(user != null){
        User loggedUser = User.fromJson(jsonDecode(user));
        String creator = loggedUser.name;
        DateTime date = DateTime.now();

        Forum newForum = Forum(title, description, creator, loggedUser.id, date);
        newForum.initialize();

       await Connection.addNewForum(newForum, group);


        return 'success';



      }else{
        return 'error';
      }

    } catch (e) {
      print(e);
      return 'error';
    }
  }

  static Future<Widget> getForums(Groups groupId)async{
    List forums = await Connection.returnForums(groupId.id.oid.toString());

    List<Widget> previews = [];

    for (var forum in forums) {
      Forum f = Forum.fromJson(forum);
      previews.add(
        MessagePreview(id:f.id, title: f.title, creator: f.creator, date: DateFormat.yMd().format(f.date), description: f.description, creator_id: f.creator_id, group: groupId,)
      );
    }

    return ListView(
      children: previews,
    );
  }
  static Future<List<ForumReplyShow>> getReplys(String forumId)async{
    
    List replys = await Connection.returnAnswers(forumId);

    List<ForumReplyShow> messages = [];

    for (var reply in replys) {
      ForumReply f = ForumReply.fromJson(reply);
      messages.add(
        ForumReplyShow(  creator: f.creator, date: DateFormat.yMd().format(f.date), message: f.message, creator_id: f.creator_id, id:f.id, forum: forumId,)
      );
    }

    return  messages;
  }

  static Future<List<ForumReplyShow>> newAnswer(String message, String forumId, List<ForumReplyShow> replys) async{
    try {
      final prefs = await SharedPreferences.getInstance();
    var userInfo = prefs.getString('user');
      if(userInfo!=null){
      User user = User.fromJson(jsonDecode(userInfo));
      DateTime date = DateTime.now();

      ForumReply reply = ForumReply(user.name, date, message, user.id);

  	  String id = await Connection.addNewReply(reply, forumId);

      replys.add(
        ForumReplyShow(creator: user.name, date: DateFormat.yMd().format(date), message: message, creator_id: user.id, id:id, forum: forumId,)
      );

      return replys;


      } else{
        return replys;
      }

    } catch (e) {
      return replys;
    }

  }

  static Future<bool> checkIfOwner(String owner)async{
    final prefs = await SharedPreferences.getInstance();
    var userInfo = await prefs.getString('user');

    if(userInfo!=null){
      User user = User.fromJson(jsonDecode(userInfo));
      return user.id == owner;
    }else{
      return false;
    }

  }

  static Future<String> deleteForum(String forumId)async{
    try {

      await Connection.removeForum(forumId, "66552c763656b63721956447");
      return 'success';
      
    } catch (e) {
      print(e);
      return 'error';
    }

  }

static Future<String> removeAnswer(String replyId, String forumId) async{
    try {

  	  await Connection.removeAnswer(replyId, forumId);

      return 'success';
        
      

    } catch (e) {
      print(e);
      return 'error';
    }

  
}

static Future<ForumView> getForum(String forumId)async{

  try {
    Forum forum = await Connection.refreshForum(forumId);

    return ForumView(date: DateFormat.yMd().format(forum.date), 
    description: forum.description, id: forum.id, title: forum.title, creator: forum.creator, creator_id: forum.creator_id);

  } catch (e) {
    return ForumView(date: "", description: "", id: "", title: "", creator: "", creator_id: "");
  }
}

static Widget manageNavigation(int index){
  switch (index) {
    case 0:
      return const JoinedGroups();
    case 1:
      return const JoinOrCreate();
    default:
      return const JoinedGroups();
  }
}

static void groupInsertion(String description, String name, User loggedUser) async{
  Groups newGroup = Groups(description, name);
  String insertedStGroupId = await Connection.insertNewGroup(loggedUser, newGroup);
  loggedUser.studyGroups.add(insertedStGroupId);
  Controller.updateUserInfo(loggedUser);
}

static Future<List<Widget>> getTopics(Groups groupId)async{

  print('hola');

  List result = await Connection.getTopics(groupId.id.oid.toString());
  List<Widget> topics=[];

  for (var t in result) {
    Topic top = Topic.forPreview(t);

    topics.add(
      TopicPreview(title: top.name, labels: top.label, topicId: top.id, groupId: groupId,)
    );
    
  }
  return topics;
}

}