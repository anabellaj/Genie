import 'package:flutter/material.dart';
import 'package:genie_app/viewModel/controllerSocial.dart';

class FollowButton extends StatefulWidget {
  const FollowButton(
      {super.key,
      required this.response,
      required this.followedUserId});

  final int response;
  final String followedUserId;
  
  
  
  
  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool isFollowing = false;
  bool isRequested = false;
  bool isStranger = false;

  @override
  void initState(){
    super.initState();
    if (widget.response == 1){
      isFollowing = true;
      setState(() {});
    } else if (widget.response == 2) {
      isRequested = true;
      setState(() {});
    } else if (widget.response == 3){
      isStranger = true;
      setState(() {});
    }
  }

  void followUser() {
    setState(() {
      isStranger = false;
      isRequested = true;
      ControllerSocial.addRequest(widget.followedUserId);


    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
    
      onPressed: (isFollowing || isRequested) ? null : followUser,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isStranger)
            Icon(Icons.person_add),
          if (isRequested)
            Icon(Icons.access_time_outlined),
          if (isFollowing)
            Icon(Icons.people),
          SizedBox(width: 8),
          Text(
            isFollowing ? 'Amigos' : (isRequested ? 'Pendiente' : 'Seguir'),
          ),
        ],
      ),
    );
  }
}