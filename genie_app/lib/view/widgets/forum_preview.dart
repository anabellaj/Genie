  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:genie_app/view/theme.dart';

class MessagePreview extends StatefulWidget{
  final String title;
  final String creator;
  final String date;
  final String description;
  const MessagePreview({super.key, required this.title, required this.creator, required this.date, required this.description});

  @override
  State<MessagePreview> createState()=> _MessagePreview();
}

class _MessagePreview extends State<MessagePreview>{

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide( color: genieThemeDataDemo.colorScheme.primary, width: 2))
        ), 
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.title,
                overflow: TextOverflow.ellipsis,
                style: genieThemeDataDemo.primaryTextTheme.titleLarge,),
              Text(widget.date,
                style: genieThemeDataDemo.textTheme.titleSmall,)],
          ),
          Text(widget.creator,
            style: genieThemeDataDemo.textTheme.titleSmall,),
          Text(widget.description,
            overflow: TextOverflow.ellipsis,
            style: genieThemeDataDemo.textTheme.displayMedium,)
          
        ],),
      )
      );
    
  }
}