
import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';

class FollowRequest extends StatefulWidget{
  const FollowRequest({super.key});

  @override
  State<FollowRequest> createState() => _FollowRequestState();
}

class _FollowRequestState extends State<FollowRequest>{

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: genieThemeDataDemo.colorScheme.primary, width: 2))),
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical:12),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("name"),
          Row(
            
            children: [
              IconButton(
            onPressed: (){print("accept");}, icon: Icon(Icons.person_add_alt, color: genieThemeDataDemo.colorScheme.primary,)),
            IconButton(
            onPressed: (){print("deny");}, icon: Icon(Icons.cancel, color: genieThemeDataDemo.colorScheme.error,))
            
            ],
          )
          
        ],),
      )
    );
  }
}