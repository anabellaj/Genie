
import 'package:flutter/material.dart';
import 'package:genie_app/view/theme.dart';
import 'package:genie_app/viewModel/JoinRequestNotification.dart';

class JoinRequest extends StatefulWidget{
  const JoinRequest({super.key, required this.id, required this.username});
  final String id;
  final String username;

  @override
  State<JoinRequest> createState() => _JoinRequestState();
}

class _JoinRequestState extends State<JoinRequest>{

  late bool added=false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: genieThemeDataDemo.colorScheme.primary, width: 2))),
      child: Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical:12),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.username),
          added?
          Icon(Icons.check, color: genieThemeDataDemo.colorScheme.primary,):
          Row(
            
            children: [
              IconButton(
            onPressed: (){
              
              JoinRequestNotification(true, widget.id).dispatch(context);
              setState(() {
                added=true;
              });
            }, icon: Icon(Icons.person_add_alt, color: genieThemeDataDemo.colorScheme.primary,)),
            IconButton(
            onPressed: (){
              JoinRequestNotification(false, widget.id).dispatch(context);
            }, icon: Icon(Icons.cancel, color: genieThemeDataDemo.colorScheme.error,))
            
            ],
          )
          
        ],),
      )
    );
  }
}