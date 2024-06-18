import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/models/user.dart';
import 'package:genie_app/view/widgets/forum_best.dart';
import 'package:genie_app/models/forum.dart';
import 'package:genie_app/view/screens/forum_view.dart';
import 'package:genie_app/view/widgets/forum_preview.dart';
import 'package:genie_app/view/widgets/forum_reply.dart';
import 'package:genie_app/models/forum_reply.dart';
import 'package:genie_app/viewModel/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ControllerForum {
  static Future<String> createNewForum(
      String title, String description, Groups group) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var user = await prefs.getString("user");
      if (user != null) {
        User loggedUser = User.fromJson(jsonDecode(user));
        String creator = loggedUser.name;
        DateTime date = DateTime.now();

        Forum newForum =
            Forum(title, description, creator, loggedUser.id, date);
        newForum.initialize();

        await Connection.addNewForum(newForum, group);

        return 'success';
      } else {
        return 'error';
      }
    } catch (e) {
      print(e);
      return 'error';
    }
  }

  static Future<List<Widget>> getForums(Groups groupId) async {
    try {
      List forums = await Connection.returnForums(groupId.id.oid.toString());

    List<Widget> previews = [];

    for (var forum in forums) {
      Forum f = Forum.fromJson(forum);
      previews.add(MessagePreview(
        id: f.id,
        title: f.title,
        creator: f.creator,
        date: DateFormat.yMd().format(f.date),
        description: f.description,
        creator_id: f.creator_id,
        group: groupId,
      ));
    }

    return previews;
    } catch (e) {
      return [];
    }
    
  }

  static Future<List<Widget>> getReplys(String forumId) async {
    try {
      List replys = await Connection.returnAnswers(forumId);
      List liked=[];
      List<ForumReply> objects=[];
    

    List<Widget> messages = [];
    for (var reply in replys){
      objects.add(ForumReply.fromJson(reply));
    }
    print(objects);
    objects.sort((a, b)=>b.num_likes.compareTo(a.num_likes));
    print(objects);
    
    
    
    messages.add(ForumBestReply(
      creator: objects[0].creator, 
      date: DateFormat.yMd().format(objects[0].date), 
      message: objects[0].message, 
      creator_id: objects[0].creator_id, id: objects[0].id, forum: forumId,
      num_likes: objects[0].num_likes,
      ));

    objects.removeAt(0);

    for (var reply in objects) {
      
      messages.add(ForumReplyShow(
        creator: reply.creator,
        date: DateFormat.yMd().format(reply.date),
        message: reply.message,
        creator_id: reply.creator_id,
        id: reply.id,
        forum: forumId,
        num_likes: reply.num_likes
        ,
      ));
    }

    return messages;
    } catch (e) {
      print(e);
      return [];
    }
    
  }

  static Future<List<Widget>> newAnswer(
      String message, String forumId, List<Widget> replys) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var userInfo = prefs.getString('user');
      if (userInfo != null) {
        User user = User.fromJson(jsonDecode(userInfo));
        DateTime date = DateTime.now();

        ForumReply reply = ForumReply(user.name, date, message, user.id, 0, false);

        String id = await Connection.addNewReply(reply, forumId);

        replys.add(ForumReplyShow(
          creator: user.name,
          date: DateFormat.yMd().format(date),
          message: message,
          creator_id: user.id,
          id: id,
          forum: forumId,
          num_likes: 0,
        ));

        return replys;
      } else {
        return replys;
      }
    } catch (e) {
      return replys;
    }
  }
  static Future<String> deleteForum(String forumId, String groupId) async {
    try {
      await Connection.removeForum(forumId, groupId);
      
      return 'success';
    } catch (e) {
      return 'error';
    }
  }

  static Future<String> removeAnswer(String replyId, String forumId) async {
    try {
      await Connection.removeAnswer(replyId, forumId);

      return 'success';
    } catch (e) {
      return 'error';
    }
  }

  static Future<ForumView> getForum(String forumId) async {
    try {
      Forum forum = await Connection.refreshForum(forumId);

      return ForumView(
          date: DateFormat.yMd().format(forum.date),
          description: forum.description,
          id: forum.id,
          title: forum.title,
          creator: forum.creator,
          creator_id: forum.creator_id);
    } catch (e) {
      return const ForumView(
          date: "",
          description: "",
          id: "",
          title: "",
          creator: "",
          creator_id: "");
    }
  }

  static Future<bool> checkLike(String replyId, String forumId)async{
    try {
      User user = await Controller.getUserInfo();
     User fullUser = await Connection.getUser(user.id);

    List liked=[];
    if(fullUser.replysLiked.isNotEmpty){
      for(var forum in fullUser.replysLiked){
        if(forum['forum']==forumId){
          liked = forum['liked'];
          if(liked.isNotEmpty){
            return liked.indexWhere((e)=> e==replyId)!=-1;
          }else{
            return false;
          }
        }
      }
      return false;
    }else{
      return false;
    }
    } catch (e) {
      return false;
    }
    
  }

  static Future updateLike(String forumId, List newReplysLiked, List remove)async{
    try {
      User user = await Controller.getUserInfo();
      User fullUser = await Connection.getUser(user.id);
      List newLikes=[...newReplysLiked];

      if(fullUser.replysLiked.isNotEmpty){
        
        if(fullUser.replysLiked.indexWhere((e)=> e['forum']==forumId)!=-1){
          print("hola");
          for(var like in fullUser.replysLiked[fullUser.replysLiked.indexWhere((e)=> e['forum']==forumId)]['liked']){
            newLikes.removeWhere((e)=>e==like);
          }
          print(fullUser.replysLiked[fullUser.replysLiked.indexWhere((e)=> e['forum']==forumId)]['liked']);
          print(newReplysLiked);
          fullUser.replysLiked[fullUser.replysLiked.indexWhere((e)=> e['forum']==forumId)]['liked']=newReplysLiked;
          print(fullUser.replysLiked[fullUser.replysLiked.indexWhere((e)=> e['forum']==forumId)]['liked']);

          await Connection.updateLikesInReplys(newLikes);
          await Connection.updateUserLikedReplys(fullUser.id, fullUser.replysLiked);
        }else{

           await Connection.updateLikesInReplys(newReplysLiked);
          await Connection.addUserLikedReplys(fullUser.id, {
            'forum':forumId,
            'liked':newReplysLiked
          });
        }
      }else{
        print('add');

        if(newReplysLiked.isNotEmpty){
          await Connection.updateLikesInReplys(newReplysLiked);
          await Connection.addUserLikedReplys(fullUser.id, {
            'forum':forumId,
            'liked':newReplysLiked
          });
        }
      }
     await Connection.removeLikes(remove);
      

    } catch (e) {
      print(e);
    }

  }

  
  

}