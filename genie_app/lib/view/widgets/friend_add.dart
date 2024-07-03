
import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/viewModel/GroupAddNotification.dart';

class FriendAdd extends StatefulWidget{
  const FriendAdd({super.key, required this.username, required this.id, required this.added});
  final String username;
  final String id;
  final bool added;

  @override
  State<FriendAdd> createState() => _FriendAddState();
}

class _FriendAddState extends State<FriendAdd>{
  late bool stateAdd = widget.added;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: genieThemeDataDemo.colorScheme.primary, width: 2))),
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical:12),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.username),
          stateAdd?
          Icon(Icons.check, color: genieThemeDataDemo.colorScheme.primary,):
          IconButton(
            onPressed: (){
              GroupAddNotification(widget.id).dispatch(context);
              setState(() {
                stateAdd=true;
              });
              }, 
            icon: Icon(Icons.person_add_alt, color: genieThemeDataDemo.colorScheme.primary,)),
            
          
          
        ],),
      )
    );
  }
}