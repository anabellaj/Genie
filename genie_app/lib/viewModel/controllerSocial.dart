// ignore: file_names
import 'package:genie_app/models/connection.dart';
import 'package:genie_app/models/following.dart';
import 'package:genie_app/models/user.dart';
import 'package:genie_app/view/widgets/follow_request.dart';
import 'package:genie_app/viewModel/controller.dart';

class ControllerSocial {
  static Future<Following> getFollowing() async {
    User user = await Controller.getUserInfo();
    Following userFollowing = await Connection.getFollowRequests(user);
    return userFollowing;
  }

  static Future<List<FollowRequest>> getFollowRequests(
      Following userFollowing) async {
    try {
      if (userFollowing.requests.isNotEmpty) {
        List<FollowRequest> requests = [];
        for (var request in userFollowing.requests) {
          requests.add(
              FollowRequest(username: request['username'], id: request['id']));
        }
        return requests;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static List<FollowRequest> removeRequest(
      List<FollowRequest> requests, String id) {
    requests.removeWhere((r) => r.id == id);
    return requests;
  }

  static Future manageRequests(List<dynamic> accept, List<dynamic> remove,
      Following userFollowing) async {
    try {
      User user = await Controller.getUserInfo();
      for (var request in accept) {
        userFollowing.requests.removeWhere((r) => r['id'] == request);
      }
      for (var request in remove) {
        userFollowing.requests.removeWhere((r) => r['id'] == request);
      }
      userFollowing.followed.addAll(accept);
      await Connection.setRequests(userFollowing, user.following);
      await Connection.addFollow(accept, user.id);
    } catch (e) {
      print('error');
      print(e);
    }
  }

  static Future addRequest(String followedUserId) async {
    try {
      User currentUser = await Controller.getUserInfo();
      await Connection.addRequest(currentUser, followedUserId);
    } catch (e) {
      print('Error $e');
    }
  }

  static Future<int> checkRequestsFollowing(String followedUserId) async {
    try {
      User currentUser = await Controller.getUserInfo();
      var response =
          await Connection.checkRequestsFollowing(currentUser, followedUserId);
      return response;
    } catch (e) {
      return 0;
    }
  }
}
