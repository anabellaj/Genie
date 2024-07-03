import 'package:flutter/material.dart';
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/models/following.dart';
import 'package:genie_app/models/group.dart';
import 'package:genie_app/models/object_id_converter.dart';
import 'package:genie_app/models/user.dart';
import 'package:genie_app/view/widgets/follow_request.dart';
import 'package:genie_app/view/widgets/friend_add.dart';
import 'package:genie_app/viewModel/controller.dart';

class ControllerSocial{
  static Future<Following> getFollowing()async{
    User user = await Controller.getUserInfo();
    Following userFollowing = await Connection.getFollowRequests(user);
    return userFollowing;

  }

  static Future<List<FollowRequest>> getFollowRequests(Following userFollowing)async{
    try {
      
      if(userFollowing.requests.isNotEmpty){
        List<FollowRequest> requests = [];
        for(var request in userFollowing.requests){
          requests.add(FollowRequest(username: request['username'], id: request['id']));
        }
        return requests;

      }else{
        return [];
      }
    } catch (e) {
      return [];
    }
    
  }
  static List<FollowRequest> removeRequest(List<FollowRequest> requests, String id){
    requests.removeWhere((r)=> r.id==id);
    return requests;
  }
  static Future manageRequests(List<dynamic> accept, List<dynamic> remove, Following userFollowing)async{
    try {
      User user = await Controller.getUserInfo();
      for(var request in accept){
        userFollowing.requests.removeWhere((r)=>r['id']==request);
      }
      for(var request in remove){
        userFollowing.requests.removeWhere((r)=>r['id']==request);
      }
      userFollowing.follows.addAll(accept);
      await Connection.setRequests(userFollowing, user.following);
      await Connection.addFollow(accept, user.id);
    } catch (e) {
      print(e);
    }
  }
  static Future<List<FriendAdd>> getFriendsToAdd(Groups group)async{
    try {
      List<FriendAdd> friends = [];
      User user = await Controller.getUserInfo();
      Following following = await ControllerSocial.getFollowing();
      List<dynamic> friendsObjectId=[];
      for (var f in following.follows){
        friendsObjectId.add(ObjectIdConverter.convertToObject(f));
      }
      List<dynamic> result = await Connection.getFriends(user.following, friendsObjectId);
      for(var r in result){
        if(group.members.contains(r['_id'].oid)){
          friends.add(FriendAdd(username: r['username'], id: r['_id'].oid, added: true,));
        }else{
          friends.add(FriendAdd(username: r['username'], id: r['_id'].oid, added: false,));
        }
        
      }
      return friends;
    } catch (e) {
      return [];
    }
  }
  static Future addNewMembers(Groups g, List<dynamic> toAdd)async{
    try {
      print(g.members.length);
      List<dynamic> toAddInId = [];
      toAdd.forEach((e){
         toAddInId.add(ObjectIdConverter.convertToObject(e));
        g.members.add(e);
      }
      );
      print(g.members.length);
      await Connection.addNewMembers(g, toAddInId);
    } catch (e) {
      print(e);
    }
  }
}