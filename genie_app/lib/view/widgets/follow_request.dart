
import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/viewModel/FollowRequestNotification.dart';

class FollowRequest extends StatefulWidget{
  const FollowRequest({super.key, required this.username, required this.id});
  final String username;
  final String id;

  @override
  State<FollowRequest> createState() => _FollowRequestState();
}

class _FollowRequestState extends State<FollowRequest>{
  late bool accepted= false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: genieThemeDataDemo.colorScheme.primary, width: 2))),
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical:12),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.username),
          accepted?
          Icon(Icons.check, color: genieThemeDataDemo.colorScheme.primary,):
          Row(
            
            children: [
              IconButton(
            onPressed: (){
              FollowRequestNotification(true, widget.id).dispatch(context);
              setState(() {
                accepted=true;
              });}, 

              icon: Icon(Icons.person_add_alt, color: genieThemeDataDemo.colorScheme.primary,)),
            IconButton(
            onPressed: (){
              FollowRequestNotification(false, widget.id).dispatch(context);}, 
              icon: Icon(Icons.cancel, color: genieThemeDataDemo.colorScheme.error,))
            
            ],
          )
          
        ],),
      )
    );
  }
}