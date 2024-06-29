
import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';

class FriendAdd extends StatefulWidget{
  const FriendAdd({super.key});

  @override
  State<FriendAdd> createState() => _FriendAddState();
}

class _FriendAddState extends State<FriendAdd>{

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: genieThemeDataDemo.colorScheme.primary, width: 2))),
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical:12),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("name"),
          IconButton(
            onPressed: (){print("accept");}, icon: Icon(Icons.person_add_alt, color: genieThemeDataDemo.colorScheme.primary,)),
            
          
          
        ],),
      )
    );
  }
}